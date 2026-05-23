import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callerName;
  final String callerNumber;
  final bool scriptedAudio;

  const IncomingCallScreen({
    super.key,
    required this.callerName,
    required this.callerNumber,
    required this.scriptedAudio,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  bool _isCallActive = false;
  int _callDurationSeconds = 0;
  Timer? _callTimer;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    // Record log entry that fake call has started ringing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.addNotification(
        title: "Fake Call Ringing",
        body: "Incoming call from ${widget.callerName} (${widget.callerNumber})",
        type: "fake_call",
      );
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    // Safeguard: Ensure ringtone is stopped when the screen is dismissed
    final appState = Provider.of<AppState>(context, listen: false);
    appState.fakeCallService.stopRinging();
    super.dispose();
  }

  void _declineCall() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.fakeCallService.stopRinging();
    appState.addNotification(
      title: "Fake Call Declined",
      body: "Call from ${widget.callerName} was declined.",
      type: "fake_call",
    );
    Navigator.of(context).pop();
  }

  void _acceptCall() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.fakeCallService.stopRinging(); // Stop the ringtone once call is accepted
    appState.addNotification(
      title: "Fake Call Connected",
      body: "Call from ${widget.callerName} answered.",
      type: "fake_call",
    );

    setState(() {
      _isCallActive = true;
    });

    _startCallTimer();
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDurationSeconds++;
        });
      }
    });
  }

  void _endActiveCall() {
    _callTimer?.cancel();
    final appState = Provider.of<AppState>(context, listen: false);
    appState.addNotification(
      title: "Fake Call Ended",
      body: "Call with ${widget.callerName} lasted ${_formatDuration(_callDurationSeconds)}.",
      type: "fake_call",
    );
    Navigator.of(context).pop();
  }

  String _formatDuration(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D15),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // Caller Info
              Text(
                widget.callerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isCallActive 
                    ? _formatDuration(_callDurationSeconds) 
                    : widget.callerNumber,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              
              const Spacer(),
              
              // Middle Avatar / Screen Display
              if (!_isCallActive) ...[
                // Flashing/pulsing visual ring for incoming call
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Active Call actions grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _CallActionButton(
                        icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                        label: 'Mute',
                        isActive: _isMuted,
                        onTap: () {
                          setState(() {
                            _isMuted = !_isMuted;
                          });
                        },
                      ),
                      _CallActionButton(
                        icon: Icons.grid_on_rounded,
                        label: 'Keypad',
                        isActive: false,
                        onTap: () {},
                      ),
                      _CallActionButton(
                        icon: _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                        label: 'Speaker',
                        isActive: _isSpeakerOn,
                        onTap: () {
                          setState(() {
                            _isSpeakerOn = !_isSpeakerOn;
                          });
                        },
                      ),
                      _CallActionButton(
                        icon: Icons.add_rounded,
                        label: 'Add Call',
                        isActive: false,
                        onTap: () {},
                      ),
                      _CallActionButton(
                        icon: Icons.video_call_rounded,
                        label: 'FaceTime',
                        isActive: false,
                        onTap: () {},
                      ),
                      _CallActionButton(
                        icon: Icons.contacts_rounded,
                        label: 'Contacts',
                        isActive: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!_isCallActive) ...[
                      // Decline Button
                      GestureDetector(
                        onTap: _declineCall,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.call_end_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Decline',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Accept Button
                      GestureDetector(
                        onTap: _acceptCall,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.call_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Accept',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // End Active Call Button
                      GestureDetector(
                        onTap: _endActiveCall,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.call_end_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'End Call',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _CallActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.black : Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
