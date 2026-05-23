import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'speech_service.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(BackgroundVoiceTaskHandler());
}

class BackgroundVoiceTaskHandler extends TaskHandler {
  SpeechService? _speechService;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("Background voice service started at $timestamp");
    
    _speechService = SpeechService();
    await _startBackgroundListening();
  }

  Future<void> _startBackgroundListening() async {
    if (_speechService == null) return;
    
    await _speechService!.startListening(
      onTrigger: () {
        debugPrint("🚨 Background Voice: EMERGENCY WORD TRIGGERED!");
        FlutterForegroundTask.sendDataToMain({'action': 'trigger_sos', 'isVoice': true});
      },
      onWords: (words) {
        debugPrint("Background Voice Recognized: $words");
        FlutterForegroundTask.sendDataToMain({'action': 'words_recognized', 'words': words});
      },
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    // Check if speech service is still listening; if not, attempt to restart it
    if (_speechService != null && !_speechService!.isListening) {
      debugPrint("Background voice service was inactive during keep-alive tick. Restarting...");
      await _startBackgroundListening();
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint("Background voice service destroyed");
    if (_speechService != null) {
      await _speechService!.stopListening();
      _speechService = null;
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }
}
