import 'package:basic/main.dart';
import 'package:flutter/material.dart';


class LiveTrackScreen extends StatefulWidget {
  const LiveTrackScreen({super.key});

  @override
  State<LiveTrackScreen> createState() => _LiveTrackScreenState();
}

class _LiveTrackScreenState extends State<LiveTrackScreen> {
  int _modeIndex = 0; // 0 live, 1 risk, 2 nearby

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Map background (use asset for perfect match)
              Positioned.fill(
                child: Image.asset(
                  'assets/live_map.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _LiveMapFallback(),
                ),
              ),

              // Soft gradient tint (matches the screenshot feel)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x6600C2FF),
                        Color(0x6615FF9A),
                        Color(0x66FFD15A),
                      ],
                    ),
                  ),
                ),
              ),

              // Top controls
              Positioned(
                left: 16,
                right: 16,
                top: 10,
                child: Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFE9ECF6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'SAFE ZONE • LOWER EAST SIDE',
                              style: TextStyle(
                                color: AppColors.textDark.withOpacity(0.85),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    _CircleIconButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Mode segmented control
              Positioned(
                left: 26,
                right: 26,
                top: 78,
                child: _ModeSegment(
                  index: _modeIndex,
                  onChanged: (v) => setState(() => _modeIndex = v),
                ),
              ),

              // Right-side map buttons
              Positioned(
                right: 16,
                top: 212,
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.22),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.my_location_rounded,
                          size: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    _MapWhiteButton(icon: Icons.add_rounded, onTap: () {}),
                    const SizedBox(height: 10),
                    _MapWhiteButton(icon: Icons.remove_rounded, onTap: () {}),
                    const SizedBox(height: 10),
                    _MapWhiteButton(icon: Icons.gps_fixed_rounded, onTap: () {}),
                  ],
                ),
              ),

              // Center location marker
              Positioned.fill(
                child: IgnorePointer(
                  child: Align(
                    alignment: const Alignment(0.0, 0.06),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Search bar
              Positioned(
                left: 16,
                right: 16,
                bottom: 118,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.94),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE9ECF6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          size: 18, color: AppColors.textMuted.withOpacity(0.9)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search safe routes...',
                          style: TextStyle(
                            color: AppColors.textMuted.withOpacity(0.75),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF2FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic_rounded,
                            size: 18, color: AppColors.primaryBlue),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom SOS
              Positioned(
                left: 0,
                right: 0,
                bottom: 18 + 0, // keep close to bottom like screenshot
                child: Center(
                  child: _SosButton(
                    onTap: () {},
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

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE9ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeChip(
              selected: index == 0,
              icon: Icons.wifi_tethering_rounded,
              label: 'Live Mode',
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _ModeChip(
              selected: index == 1,
              icon: Icons.mic_none_rounded,
              label: 'Risk\nHeatmap',
              twoLines: true,
              onTap: () => onChanged(1),
            ),
          ),
          Expanded(
            child: _ModeChip(
              selected: index == 2,
              icon: Icons.location_on_outlined,
              label: 'Nearby',
              onTap: () => onChanged(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
    this.twoLines = false,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool twoLines;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : AppColors.textMuted.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textMuted.withOpacity(0.95),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  height: twoLines ? 1.05 : 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE9ECF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textDark.withOpacity(0.9), size: 22),
      ),
    );
  }
}

class _MapWhiteButton extends StatelessWidget {
  const _MapWhiteButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE9ECF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.primaryBlue),
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 98,
        height: 98,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.55),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.18),
              blurRadius: 30,
              offset: const Offset(0, 18),
            )
          ],
        ),
        child: Center(
          child: Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.22),
                  blurRadius: 26,
                  offset: const Offset(0, 16),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
                    Positioned(
                      top: 5,
                      child: Icon(Icons.priority_high_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveMapFallback extends StatelessWidget {
  const _LiveMapFallback();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LiveMapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _LiveMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE7F0EA);
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    final thin = Paint()
      ..color = Colors.white.withOpacity(0.38)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    Path p1 = Path()
      ..moveTo(size.width * 0.04, size.height * 0.20)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.12, size.width * 0.58, size.height * 0.28)
      ..quadraticBezierTo(size.width * 0.82, size.height * 0.46, size.width * 0.96, size.height * 0.62);

    Path p2 = Path()
      ..moveTo(size.width * 0.10, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.38, size.height * 0.74, size.width * 0.58, size.height * 0.58)
      ..quadraticBezierTo(size.width * 0.76, size.height * 0.44, size.width * 0.94, size.height * 0.34);

    Path p3 = Path()
      ..moveTo(size.width * 0.20, size.height * 0.08)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.34, size.width * 0.36, size.height * 0.52)
      ..quadraticBezierTo(size.width * 0.50, size.height * 0.78, size.width * 0.66, size.height * 0.92);

    canvas.drawPath(p1, road);
    canvas.drawPath(p2, road);
    canvas.drawPath(p3, thin);

    final blocks = Paint()..color = Colors.white.withOpacity(0.10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.10, size.height * 0.32, size.width * 0.24, size.height * 0.20),
        const Radius.circular(18),
      ),
      blocks,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.64, size.height * 0.14, size.width * 0.20, size.height * 0.18),
        const Radius.circular(18),
      ),
      blocks,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}