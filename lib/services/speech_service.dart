import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _isResetting = false;
  bool _isExecutingListen = false; // Guard against concurrent _listen executions
  Function()? _onEmergencyTriggered;
  Function(String text)? _onWordsRecognized;

  int _currentSessionHelpCount = 0;
  final List<DateTime> _helpTimestamps = [];
  Timer? _reboundTimer;
  Timer? _restartTimer;
  int _consecutiveErrorCount = 0;

  bool get isListening => _isListening;
  bool _mutedForSpeech = false;

  // Native MethodChannel for audio muting — works in background isolates (no ActivityAware needed)
  static const _audioMuteChannel = MethodChannel('com.hutter.app/audio_mute');

  // AudioManager stream type constants (mirrors Android AudioManager)
  static const int _streamSystem = 1;
  static const int _streamMusic = 3;
  static const int _streamNotification = 5;

  Future<void> _muteSystemSounds() async {
    if (_mutedForSpeech) return;
    try {
      // Mute system, notification, and music streams to silence SpeechRecognizer start/stop beeps
      await _audioMuteChannel.invokeMethod('muteMultipleStreams', {
        'streamTypes': [_streamSystem, _streamNotification, _streamMusic],
        'mute': true,
      });
      _mutedForSpeech = true;
      debugPrint('SpeechService: Muted system/notification/music streams for beep suppression.');
    } catch (e) {
      debugPrint('SpeechService: Failed to mute system sounds: $e');
    }
  }

  Future<void> _unmuteSystemSounds() async {
    if (!_mutedForSpeech) return;
    try {
      await _audioMuteChannel.invokeMethod('muteMultipleStreams', {
        'streamTypes': [_streamSystem, _streamNotification, _streamMusic],
        'mute': false,
      });
      _mutedForSpeech = false;
      debugPrint('SpeechService: Restored system/notification/music streams.');
    } catch (e) {
      debugPrint('SpeechService: Failed to restore system sounds: $e');
    }
  }

  // Schedule a single restart attempt safely
  void _scheduleRestart(Duration delay) {
    _restartTimer?.cancel();
    _restartTimer = Timer(delay, () {
      if (_isListening) {
        _listen();
      }
    });
  }

  // Initialize and check device availability
  Future<bool> initialize() async {
    try {
      return await _speech.initialize(
        onError: (val) {
          _consecutiveErrorCount++;
          debugPrint('Speech error: ${val.errorMsg} (Consecutive: $_consecutiveErrorCount)');
          
          if (_isListening && !_isResetting) {
            _currentSessionHelpCount = 0;
            
            // Apply gradual backoff retry based on error count to prevent CPU spin and battery drain
            int delaySeconds = 3;
            if (_consecutiveErrorCount >= 2) {
              delaySeconds = 10;
            }
            if (_consecutiveErrorCount >= 4) {
              delaySeconds = 30;
            }
            
            _scheduleRestart(Duration(seconds: delaySeconds));
          }
        },
        onStatus: (val) {
          debugPrint('Speech status: $val');
          if (val == 'listening') {
            _consecutiveErrorCount = 0;
          } else if (_isListening && !_isResetting && (val == 'done' || val == 'notListening')) {
            _currentSessionHelpCount = 0;
            // Only trigger default transition restart if there is no ongoing error backoff
            if (_consecutiveErrorCount == 0) {
              _scheduleRestart(const Duration(milliseconds: 1500));
            }
          }
        },
      );
    } catch (_) {
      return false; // Speech not supported on this device/platform
    }
  }

  // Start continuous listening loop
  Future<void> startListening({
    required Function() onTrigger,
    Function(String text)? onWords,
  }) async {
    _onEmergencyTriggered = onTrigger;
    _onWordsRecognized = onWords;

    final available = await initialize();
    if (!available) {
      // If speech engine is unavailable (e.g. simulator/web), start a simulated timer that acts as a mockup
      _isListening = true;
      debugPrint('Speech recognition unavailable. Starting speech simulator mode.');
      return;
    }

    _isListening = true;
    _helpTimestamps.clear();
    _currentSessionHelpCount = 0;
    _consecutiveErrorCount = 0;
    
    // Mute system, notification and music streams before starting
    await _muteSystemSounds();
    _listen();
  }

  Future<void> _listen() async {
    if (!_isListening) return;
    if (_isExecutingListen) {
      debugPrint('Already executing _listen, skipping active _listen call.');
      return;
    }
    
    _isExecutingListen = true;
    try {
      if (_speech.isListening) {
        debugPrint('Speech is already listening, skipping active _listen call.');
        return;
      }

      _isResetting = true;
      try {
        await _speech.cancel();
      } catch (e) {
        debugPrint("Error canceling speech session: $e");
      }
      _isResetting = false;

      // Check again in case state changed during asynchronous cancel
      if (!_isListening) return;

      try {
        // Ensure streams are muted for the start beep transition
        await _muteSystemSounds();

        await _speech.listen(
          onResult: (result) {
            final text = result.recognizedWords.toLowerCase();
            debugPrint('Speech recognized: $text');
            
            if (text.isNotEmpty) {
              _consecutiveErrorCount = 0; // Got words, reset error state
            }
            
            if (_onWordsRecognized != null) {
              _onWordsRecognized!(result.recognizedWords);
            }

            // Keywords detection
            final containsDanger = text.contains('danger') || text.contains('dansongs') || text.contains('denger');
            final containsTrouble = text.contains('trouble') ||
                text.contains('truble') ||
                text.contains('ia m truble') ||
                text.contains('i am trouble') ||
                text.contains('i am in trouble') ||
                text.contains('i\'m in trouble');

            // Robust Help tracking across pauses/session boundaries (with more phonetic variants)
            final helpCount = RegExp(r'(help|hlep|halp|held|health|hell|hep|hilp|kelp)').allMatches(text).length;
            if (helpCount > _currentSessionHelpCount) {
              final newHelps = helpCount - _currentSessionHelpCount;
              for (int i = 0; i < newHelps; i++) {
                _helpTimestamps.add(DateTime.now());
              }
              _currentSessionHelpCount = helpCount;
            }

            // Filter out timestamps older than 15 seconds
            _helpTimestamps.removeWhere((t) => DateTime.now().difference(t).inSeconds > 15);
            
            // Triggers on "help help" sequence or if there are 2 or more helps registered
            final containsHelpHelp = text.contains('help help') || 
                text.contains('hlep hlep') || 
                text.contains('halp halp') ||
                text.contains('held held') ||
                text.contains('hep hep') ||
                _helpTimestamps.length >= 2;

            if (containsDanger || containsTrouble || containsHelpHelp ||
                text.contains('save me') ||
                text.contains('emergency') ||
                text.contains('police')) {
              if (_onEmergencyTriggered != null) {
                _onEmergencyTriggered!();
              }
              _helpTimestamps.clear(); // Clear to prevent double triggering
              _currentSessionHelpCount = 0;
            }
          },
          listenOptions: SpeechListenOptions(
            partialResults: true,
            onDevice: false, // Set to false to support iOS out of the box where local models are not downloaded
            listenFor: const Duration(seconds: 30),
            pauseFor: const Duration(seconds: 5),
          ),
        );

        // Schedule unmuting of streams 1 second after starting to allow the start beep to pass silently
        Timer(const Duration(seconds: 1), () {
          if (_isListening && _consecutiveErrorCount == 0) {
            _unmuteSystemSounds();
          }
        });
      } catch (e) {
        debugPrint("Exception in speech.listen: $e");
        _consecutiveErrorCount++;
        _scheduleRestart(const Duration(seconds: 3));
      }
    } finally {
      _isExecutingListen = false;
    }

    _reboundTimer?.cancel();
    _reboundTimer = Timer(const Duration(seconds: 35), () {
      if (_isListening) {
        _listen();
      }
    });
  }

  // Stop listening
  Future<void> stopListening() async {
    _isListening = false;
    _restartTimer?.cancel();
    _reboundTimer?.cancel();
    _currentSessionHelpCount = 0;
    _consecutiveErrorCount = 0;
    _helpTimestamps.clear();
    await _speech.cancel();
    // Restore system, notification and music streams when stopping
    await _unmuteSystemSounds();
  }

  // Simulator helper to trigger SOS manually in the chat or dashboard
  void simulateVoiceTrigger() {
    if (_onEmergencyTriggered != null) {
      _onEmergencyTriggered!();
    }
  }
}
