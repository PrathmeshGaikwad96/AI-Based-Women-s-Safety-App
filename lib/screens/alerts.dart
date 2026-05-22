import 'package:flutter/material.dart';
import '../main.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _tab = 0; // 0 = Active, 1 = Past

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _AlertsBottomNav(
          currentIndex: 1,
          onChanged: (i) {
            if (i == 0) {
              Navigator.pop(context); // back to Home (pushed from Home)
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top title row
                Row(
                  children: [
                    Text(
                      'Alerts History',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppColors.primaryBlue.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Segmented control
                _SegmentedTabs(
                  leftText: 'Active',
                  rightText: 'Past',
                  index: _tab,
                  onChanged: (v) => setState(() => _tab = v),
                ),
                const SizedBox(height: 14),

                // LIVE INCIDENTS
                Row(
                  children: [
                    Text(
                      'LIVE INCIDENTS',
                      style: TextStyle(
                        color: const Color(0xFFFF4D77),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.9,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D77),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                const _LiveIncidentCard(),

                const SizedBox(height: 18),

                Text(
                  'PAST ALERTS HISTORY',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.95),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 10),

                const _PastAlertsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.leftText,
    required this.rightText,
    required this.index,
    required this.onChanged,
  });

  final String leftText;
  final String rightText;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegTab(
              text: leftText,
              selected: index == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _SegTab(
              text: rightText,
              selected: index == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegTab extends StatelessWidget {
  const _SegTab({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? AppColors.primaryBlue : AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveIncidentCard extends StatelessWidget {
  const _LiveIncidentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFB3C4), width: 1.6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4D77).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // status chips row
          Row(
            children: [
              _Pill(
                text: 'EMERGENCY TRIGGERED',
                bg: const Color(0xFFF5F6FA),
                fg: AppColors.textMuted.withOpacity(0.95),
                border: const Color(0xFFE8EBF4),
              ),
              const Spacer(),
              _Pill(
                text: 'IN PROGRESS',
                bg: const Color(0xFFFFE8EF),
                fg: const Color(0xFFFF4D77),
                border: const Color(0xFFFFD1DD),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            'Main St & 5th Ave',
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 14, color: AppColors.textMuted.withOpacity(0.9)),
              const SizedBox(width: 6),
              Text(
                'Started 2 mins ago',
                style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.95),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.mic_none_rounded,
                  size: 14, color: AppColors.textMuted.withOpacity(0.9)),
              const SizedBox(width: 6),
              Text(
                'Voice Command',
                style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.95),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // map
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const SizedBox(
              height: 118,
              width: double.infinity,
              child: _MiniMap(),
            ),
          ),

          const SizedBox(height: 12),

          // buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.20),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.videocam_rounded, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'View Live',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFE6EAF4)),
                      ),
                      child: const Center(
                        child: Text(
                          "I'm Safe",
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.55,
        ),
      ),
    );
  }
}

class _MiniMap extends StatelessWidget {
  const _MiniMap();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _MiniMapPainter(),
          ),
        ),
        // Blue location dot
        Center(
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
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // green base like screenshot
    final bg = Paint()..color = const Color(0xFFB8D5B7);
    canvas.drawRect(Offset.zero & size, bg);

    // subtle overlay
    final overlay = Paint()..color = Colors.white.withOpacity(0.10);
    canvas.drawRect(Offset.zero & size, overlay);

    // roads
    final road = Paint()
      ..color = Colors.white.withOpacity(0.68)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final roadThin = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    // Draw a few road-like curves to resemble the map tile
    final p1 = Path()
      ..moveTo(size.width * 0.08, size.height * 0.20)
      ..quadraticBezierTo(
          size.width * 0.40, size.height * 0.12, size.width * 0.62, size.height * 0.30)
      ..quadraticBezierTo(
          size.width * 0.82, size.height * 0.46, size.width * 0.92, size.height * 0.66);

    final p2 = Path()
      ..moveTo(size.width * 0.12, size.height * 0.78)
      ..quadraticBezierTo(
          size.width * 0.40, size.height * 0.72, size.width * 0.58, size.height * 0.56)
      ..quadraticBezierTo(
          size.width * 0.72, size.height * 0.44, size.width * 0.90, size.height * 0.36);

    final p3 = Path()
      ..moveTo(size.width * 0.20, size.height * 0.10)
      ..quadraticBezierTo(
          size.width * 0.26, size.height * 0.36, size.width * 0.34, size.height * 0.52)
      ..quadraticBezierTo(
          size.width * 0.48, size.height * 0.78, size.width * 0.64, size.height * 0.92);

    canvas.drawPath(p1, road);
    canvas.drawPath(p2, road);
    canvas.drawPath(p3, roadThin);

    // blocks/parks
    final block = Paint()..color = Colors.white.withOpacity(0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.10, size.height * 0.34, size.width * 0.22, size.height * 0.22),
        const Radius.circular(10),
      ),
      block,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.66, size.height * 0.12, size.width * 0.18, size.height * 0.18),
        const Radius.circular(10),
      ),
      block,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PastAlertsCard extends StatelessWidget {
  const _PastAlertsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: Column(
        children: const [
          _PastAlertTile(
            title: 'Union Square\nPark',
            subtitle: 'Panic Button • Triggered by AI',
            trailing: 'Oct 12, 10:45\nPM',
            icon: Icons.location_on_rounded,
          ),
          SizedBox(height: 12),
          _TileDivider(),
          _PastAlertTile(
            title: 'Broadway\nTheater',
            subtitle: 'False Alarm • Cancelled via PIN',
            trailing: 'Oct 01, 11:20\nPM',
            icon: Icons.theater_comedy_rounded,
          ),
           SizedBox(height: 12),
          _TileDivider(),
          _PastAlertTile(
            title: '32nd St\nStation',
            subtitle: 'Resolved • AI Audio Analysis Trigger',
            trailing: 'Sep 29, 08:15\nPM',
            icon: Icons.train_rounded,
          ),
        ],
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Divider(
        height: 1,
        thickness: 1,
        color: const Color(0xFFE9ECF6),
      ),
    );
  }
}

class _PastAlertTile extends StatelessWidget {
  const _PastAlertTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.95),
                    fontSize: 10.8,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailing,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.95),
                  fontSize: 10.6,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 6),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppColors.textMuted.withOpacity(0.55)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AlertsBottomNav extends StatelessWidget {
  const _AlertsBottomNav({
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -10),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onChanged,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: const Color(0xFFB5B9C7),
        selectedLabelStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.change_circle_rounded),
            label: 'Circle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}