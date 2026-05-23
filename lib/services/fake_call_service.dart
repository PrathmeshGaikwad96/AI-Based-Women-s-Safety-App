import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

/// FakeCallService triggers a simulated incoming phone call.
///
/// The native [flutter_callkit_incoming] package was removed because it depends on
/// old Kotlin artifacts (kotlin-parcelize-runtime:1.5.30) that cannot be resolved
/// in all network environments. This implementation achieves the same UX by:
/// - Playing the system ringtone via [flutter_ringtone_player]
/// - Delegating the call screen display to the app's own overlay widget (FakeCallOverlay)
///   which is triggered via the [onTrigger] callback already set up in the call sites.
class FakeCallService {
  Timer? _timer;
  bool _isScheduled = false;
  String _callerName = 'Mom';
  String _callerNumber = '+1 (555) 987-6543';

  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();

  bool get isScheduled => _isScheduled;
  String get callerName => _callerName;
  String get callerNumber => _callerNumber;

  // Schedule fake call
  void scheduleCall({
    required String name,
    required String number,
    required Duration delay,
    required Function() onTrigger,
  }) {
    cancelCall(); // Cancel any existing scheduled call

    _callerName = name;
    _callerNumber = number;

    if (delay == Duration.zero) {
      _triggerCall(name, number, onTrigger);
      return;
    }

    _isScheduled = true;
    _timer = Timer(delay, () {
      _isScheduled = false;
      _triggerCall(name, number, onTrigger);
    });
  }

  // Convenience wrapper used by fake_call screen
  void scheduleFakeCall({
    required int delaySeconds,
    required String callerName,
    required Function() onRing,
  }) {
    scheduleCall(
      name: callerName,
      number: '+91 98765 43210',
      delay: Duration(seconds: delaySeconds),
      onTrigger: onRing,
    );
  }

  void cancelCall() {
    _timer?.cancel();
    _isScheduled = false;
    _stopRingtone();
  }

  void stopRinging() => _stopRingtone();

  void _triggerCall(String name, String number, Function() onTrigger) {
    // Play the default system ringtone to simulate an incoming call
    _startRingtone();
    // Notify the UI layer to display the fake call overlay screen
    onTrigger();
  }

  Future<void> _startRingtone() async {
    try {
      await _ringtonePlayer.playRingtone(looping: true, asAlarm: false);
    } catch (e) {
      // Fallback silently if ringtone player fails
    }
  }

  Future<void> _stopRingtone() async {
    try {
      await _ringtonePlayer.stop();
    } catch (e) {
      // Ignore
    }
  }
}
