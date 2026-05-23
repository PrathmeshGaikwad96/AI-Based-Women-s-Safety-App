import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../state/app_state.dart';
import '../state/auth_state.dart';

class SosAlertScreen extends StatefulWidget {
  const SosAlertScreen({super.key});

  @override
  State<SosAlertScreen> createState() => _SosAlertScreenState();
}

class _SosAlertScreenState extends State<SosAlertScreen> {
  int _seconds = 5;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds <= 0) {
        t.cancel();
        return;
      }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _cancelSosEmergency() async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.cancelSOS("0000");
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Background map
              Positioned.fill(
                child: Image.asset(
                  'assets/sos_map.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _SosMapFallback(),
                ),
              ),

              // Dark blue overlay like screenshot
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF0E2B57).withOpacity(0.62),
                ),
              ),

              // Top pill
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _TopStatusPill(
                      leftText: 'SOS ACTIVE - AI MONITORING',
                      rightText: '94%',
                      onBack: _cancelSosEmergency,
                    ),
                  ),
                ),
              ),

              // Center modal card
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Consumer<AppState>(
                    builder: (context, appState, _) => _DispatchCard(
                      seconds: _seconds,
                      onCall: () {
                        // Launch dial intent (simulated)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Calling emergency services: 112'),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      },
                      onCancel: _cancelSosEmergency,
                    ),
                  ),
                ),
              ),

              // Bottom address bar
              Positioned(
                left: 18,
                right: 18,
                bottom: 14 + bottomInset,
                child: Consumer<AppState>(
                  builder: (context, appState, _) => _BottomAddressBar(
                    label: 'CURRENT ADDRESS',
                    address: appState.currentAddress,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopStatusPill extends StatelessWidget {
  const _TopStatusPill({
    required this.leftText,
    required this.rightText,
    required this.onBack,
  });

  final String leftText;
  final String rightText;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE9ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onBack,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4FA),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE9ECF6)),
              ),
              child: const Icon(Icons.chevron_left_rounded,
                  size: 18, color: AppColors.textDark),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFFFF3B30),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              leftText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFFF3B30),
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.bolt_rounded, size: 16, color: AppColors.primaryBlue),
          const SizedBox(width: 4),
          Text(
            rightText,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _DispatchCard extends StatelessWidget {
  const _DispatchCard({
    required this.seconds,
    required this.onCall,
    required this.onCancel,
  });

  final int seconds;
  final VoidCallback onCall;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final s = seconds.clamp(0, 99).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E9EF),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 34,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'POLICE DISPATCH IN',
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.95),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          // Countdown with ring
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFF3B30).withOpacity(0.22),
                      width: 3,
                    ),
                  ),
                ),
                Text(
                  s,
                  style: const TextStyle(
                    color: Color(0xFFFF3B30),
                    fontSize: 74,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Your live location is being shared\nwith emergency responders and\nsafety contacts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.95),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),

          // Call button wrapper (light red bg like screenshot)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onCall,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF3B30).withOpacity(0.20),
                        blurRadius: 22,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.call_rounded, size: 18, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'CALL POLICE NOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Cancel button
          SizedBox(
            height: 48,
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onCancel,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E6ED),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFD5D9E3)),
                ),
                child: const Center(
                  child: Text(
                    'CANCEL SOS ALARM',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAddressBar extends StatelessWidget {
  const _BottomAddressBar({
    required this.label,
    required this.address,
  });

  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on_rounded,
                size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.95),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4FA),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.share_rounded,
                size: 18, color: AppColors.primaryBlue.withOpacity(0.95)),
          ),
        ],
      ),
    );
  }
}

class _SosMapFallback extends StatelessWidget {
  const _SosMapFallback();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SosMapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _SosMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE6EEF8);
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFFB7C6DA).withOpacity(0.7)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final p1 = Path()
      ..moveTo(size.width * 0.06, size.height * 0.22)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.12,
          size.width * 0.62, size.height * 0.28)
      ..quadraticBezierTo(size.width * 0.84, size.height * 0.42,
          size.width * 0.96, size.height * 0.60);

    final p2 = Path()
      ..moveTo(size.width * 0.10, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.38, size.height * 0.72,
          size.width * 0.58, size.height * 0.58)
      ..quadraticBezierTo(size.width * 0.76, size.height * 0.44,
          size.width * 0.94, size.height * 0.34);

    canvas.drawPath(p1, road);
    canvas.drawPath(p2, road);

    final blocks = Paint()..color = const Color(0xFF94A3B8).withOpacity(0.10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.12, size.height * 0.30,
            size.width * 0.26, size.height * 0.20),
        const Radius.circular(18),
      ),
      blocks,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.62, size.height * 0.18,
            size.width * 0.22, size.height * 0.18),
        const Radius.circular(18),
      ),
      blocks,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}