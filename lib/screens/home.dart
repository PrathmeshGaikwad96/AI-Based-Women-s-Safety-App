import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../state/app_state.dart';
import '../state/auth_state.dart';
import 'alerts.dart';
import 'profile.dart';
import 'sos_alert.dart';
import 'live_track.dart';
import 'fake_call.dart';
import 'your_rights.dart';
import 'safety_store.dart';
import 'government_scheme.dart';
import 'ai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _pulseCtrl;
  bool _isSosScreenPushed = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _onBottomNavTap(int i) async {
    if (i == 1) {
      setState(() => _currentIndex = 1);
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AlertsScreen()),
      );
      if (!mounted) return;
      setState(() => _currentIndex = 0);
      return;
    }
    if (i == 2) {
      setState(() => _currentIndex = 2);
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AiScreen()),
      );
      if (!mounted) return;
      setState(() => _currentIndex = 0);
      return;
    }
    if (i == 3) {
      setState(() => _currentIndex = 3);
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
      if (!mounted) return;
      setState(() => _currentIndex = 0);
      return;
    }
    setState(() => _currentIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    final user = authState.currentUser;

    if (user != null && appState.currentUserId != user.uid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AppState>(context, listen: false).loadUserData(user.uid);
      });
    }

    if (appState.isSosActive && appState.sosCountdown == 0 && appState.activeAlert != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isSosScreenPushed) {
          _isSosScreenPushed = true;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SosAlertScreen()),
          ).then((_) {
            _isSosScreenPushed = false;
          });
        }
      });
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        bottomNavigationBar: _BottomNav(
          currentIndex: _currentIndex,
          onChanged: _onBottomNavTap,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──────────────────────────────────────────────
                _TopHeader(
                  name: user?.name ?? 'Maya',
                  address: appState.currentAddress,
                  onBellTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlertsScreen()),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Threat Banner (shows only when in a risk zone) ──────
                if (appState.isEnteringThreat && appState.nearbyThreat != null)
                  _ThreatBanner(threatName: appState.nearbyThreat!.name, riskLevel: appState.nearbyThreat!.riskLevel),
                if (appState.isEnteringThreat) const SizedBox(height: 12),

                // ── AI Safety Score Card ────────────────────────────────
                _SafetyScoreCard(
                  score: appState.safetyScore,
                  isInThreat: appState.isEnteringThreat,
                ),
                const SizedBox(height: 20),

                // ── SOS Button ──────────────────────────────────────────
                _SosButton(
                  pulseController: _pulseCtrl,
                  isSosActive: appState.isSosActive,
                  sosCountdown: appState.sosCountdown,
                  onTapTrigger: () {
                    appState.startSOSCountdown(user, () {});
                  },
                  onCancel: () => appState.cancelSOSCountdown(),
                ),
                const SizedBox(height: 12),

                // ── Helper instruction text ──────────────────────────────
                Text(
                  'In an emergency, tap the button to\nnotify your guardians and local\nauthorities immediately.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Quick Actions Grid ───────────────────────────────────
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'QUICK ACTIONS',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _QuickActionsGrid(
                  onLiveTrackTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LiveTrackScreen()),
                  ),
                  onFakeCallTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FakeCallScreen()),
                  ),
                  onYourRightsTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const YourRightsScreen()),
                  ),
                  onSafetyGearTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SafetyStoreScreen()),
                  ),
                  onSchemesTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GovernmentSchemeScreen()),
                  ),
                  onAIAssistantTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AiScreen()),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Safety Circle Status ─────────────────────────────────
                if (appState.guardians.isNotEmpty)
                  _SafetyCircleCard(guardians: appState.guardians),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Top Header ──────────────────────────────────────────────────────────────
class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.name,
    required this.address,
    required this.onBellTap,
  });

  final String name;
  final String address;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF6A5CFF), Color(0xFFFF5EA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.1,
                    color: AppColors.textDark,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Hello, ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: ' 👋'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 13, color: AppColors.primaryBlue.withOpacity(0.9)),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primaryBlue.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onBellTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(Icons.notifications_none_rounded, size: 21, color: AppColors.textMuted.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}

// ─── Threat Banner ────────────────────────────────────────────────────────────
class _ThreatBanner extends StatelessWidget {
  const _ThreatBanner({required this.threatName, required this.riskLevel});
  final String threatName;
  final String riskLevel;

  @override
  Widget build(BuildContext context) {
    final isHigh = riskLevel == 'High Risk';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isHigh ? AppColors.danger.withOpacity(0.08) : Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isHigh ? AppColors.danger.withOpacity(0.3) : Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: isHigh ? AppColors.danger : Colors.orange, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠ $riskLevel Area Detected',
                  style: TextStyle(
                    color: isHigh ? AppColors.danger : Colors.orange,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
                Text(
                  threatName,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isHigh ? AppColors.danger : Colors.orange),
        ],
      ),
    );
  }
}

// ─── Safety Score Card ────────────────────────────────────────────────────────
class _SafetyScoreCard extends StatelessWidget {
  const _SafetyScoreCard({required this.score, required this.isInThreat});
  final double score;
  final bool isInThreat;

  @override
  Widget build(BuildContext context) {
    final scoreInt = score.round();
    Color scoreColor;
    String statusText;
    String ringText;
    if (scoreInt >= 90) {
      scoreColor = AppColors.success;
      statusText = 'Surroundings Secure';
      ringText = 'SAFE';
    } else if (scoreInt >= 70) {
      scoreColor = Colors.orange;
      statusText = 'Moderate Risk Nearby';
      ringText = 'WARN';
    } else {
      scoreColor = AppColors.danger;
      statusText = 'High Danger Zone!';
      ringText = 'RISK';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 22, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Safety Score',
                  style: TextStyle(color: AppColors.textMuted.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '$scoreInt%',
                  style: TextStyle(color: scoreColor, fontSize: 26, fontWeight: FontWeight.w800, height: 1.0),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      scoreInt >= 90 ? Icons.check_circle_rounded : Icons.warning_rounded,
                      size: 13,
                      color: scoreColor,
                    ),
                    const SizedBox(width: 5),
                    Text(statusText, style: TextStyle(color: scoreColor, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 66,
            height: 66,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 66,
                  height: 66,
                  child: CircularProgressIndicator(
                    value: (score / 100).clamp(0.0, 1.0),
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFE9ECF6),
                    valueColor: AlwaysStoppedAnimation(scoreColor),
                  ),
                ),
                Text(
                  ringText,
                  style: TextStyle(color: scoreColor, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SOS Button ───────────────────────────────────────────────────────────────
class _SosButton extends StatelessWidget {
  const _SosButton({
    required this.pulseController,
    required this.isSosActive,
    required this.sosCountdown,
    required this.onTapTrigger,
    required this.onCancel,
  });

  final AnimationController pulseController;
  final bool isSosActive;
  final int sosCountdown;
  final VoidCallback onTapTrigger;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: isSosActive ? onCancel : onTapTrigger,
        child: SizedBox(
          width: 248,
          height: 248,
          child: AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final pulseScale = 1.0 + (pulseController.value * 0.05);
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulse ring
                  Transform.scale(
                    scale: pulseScale,
                    child: Container(
                      width: 248,
                      height: 248,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSosActive
                            ? AppColors.danger.withOpacity(0.08 + (pulseController.value * 0.06))
                            : const Color(0xFFEEEFFA),
                      ),
                    ),
                  ),
                  // Middle ring
                  Container(
                    width: 208,
                    height: 208,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSosActive ? AppColors.danger.withOpacity(0.12) : const Color(0xFFE6E8F6),
                    ),
                  ),
                  // Inner button
                  Container(
                    width: 164,
                    height: 164,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSosActive
                            ? [AppColors.danger, const Color(0xFFCC1A10)]
                            : [const Color(0xFF0B1AD1), const Color(0xFF0711A3)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isSosActive ? AppColors.danger : AppColors.primaryBlue).withOpacity(0.30),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSosActive && sosCountdown > 0) ...[
                          Text(
                            '$sosCountdown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'TAP TO CANCEL',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ] else ...[
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.wifi_rounded, color: Colors.white, size: 30),
                              Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Icon(Icons.location_on_rounded, color: Colors.white.withOpacity(0.9), size: 22),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'SOS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'TAP TO ALERT',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Quick Actions Grid ───────────────────────────────────────────────────────
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.onLiveTrackTap,
    required this.onFakeCallTap,
    required this.onYourRightsTap,
    required this.onSafetyGearTap,
    required this.onSchemesTap,
    required this.onAIAssistantTap,
  });

  final VoidCallback onLiveTrackTap;
  final VoidCallback onFakeCallTap;
  final VoidCallback onYourRightsTap;
  final VoidCallback onSafetyGearTap;
  final VoidCallback onSchemesTap;
  final VoidCallback onAIAssistantTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _QuickCard(
          icon: Icons.my_location_rounded,
          iconBg: const Color(0xFFE9ECFF),
          iconColor: AppColors.primaryBlue,
          title: 'Live Track',
          subtitle: 'Share real-time path',
          onTap: onLiveTrackTap,
        ),
        _QuickCard(
          icon: Icons.call_rounded,
          iconBg: const Color(0xFFFFE6F1),
          iconColor: AppColors.pink,
          title: 'Fake Call',
          subtitle: 'Instant exit strategy',
          onTap: onFakeCallTap,
        ),
        _QuickCard(
          icon: Icons.gavel_rounded,
          iconBg: const Color(0xFFE9ECFF),
          iconColor: AppColors.primaryBlue,
          title: 'Your Rights',
          subtitle: 'Legal AI assistance',
          onTap: onYourRightsTap,
        ),
        _QuickCard(
          icon: Icons.shopping_bag_rounded,
          iconBg: const Color(0xFFE9ECFF),
          iconColor: AppColors.primaryBlue,
          title: 'Safety Gear',
          subtitle: 'Tools & devices',
          onTap: onSafetyGearTap,
        ),
        _QuickCard(
          icon: Icons.account_balance_rounded,
          iconBg: const Color(0xFFEFEAFF),
          iconColor: AppColors.purple,
          title: 'Gov. Schemes',
          subtitle: 'Aid & scholarships',
          onTap: onSchemesTap,
        ),
        _QuickCard(
          icon: Icons.smart_toy_rounded,
          iconBg: const Color(0xFFFFE6F1),
          iconColor: AppColors.pink,
          title: 'AI Assistant',
          subtitle: 'Smart safety chat',
          onTap: onAIAssistantTap,
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textMuted.withOpacity(0.95),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Safety Circle Preview Card ───────────────────────────────────────────────
class _SafetyCircleCard extends StatelessWidget {
  const _SafetyCircleCard({required this.guardians});
  final dynamic guardians;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_rounded, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Safety Circle Active',
                  style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800, fontSize: 13),
                ),
                Text(
                  '${guardians.length} guardian${guardians.length != 1 ? "s" : ""} connected & monitoring',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
        ],
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onChanged});

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
            offset: const Offset(0, -8),
          ),
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
        unselectedLabelStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_rounded), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}