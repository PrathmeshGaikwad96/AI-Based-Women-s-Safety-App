import 'dart:async';
import 'package:basic/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import 'auth/login.dart';
import 'home.dart';

/// ---------- Screen 1: Splash / Initializing ----------
class SplashInitializingScreen extends StatefulWidget {
  const SplashInitializingScreen({super.key});

  @override
  State<SplashInitializingScreen> createState() => _SplashInitializingScreenState();
}

class _SplashInitializingScreenState extends State<SplashInitializingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Screenshot shows ~35%
    _progress = Tween<double>(begin: 0.0, end: 0.50).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic),
    );

    _c.forward();

    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final authState = Provider.of<AuthState>(context, listen: false);
      
      Widget nextScreen;
      if (authState.isAuthenticated) {
        nextScreen = const HomeScreen();
      } else {
        nextScreen = const LoginScreen();
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, __, ___) => nextScreen,
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Matches the very light, clean background
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final h = c.maxHeight;
            return Stack(
              children: [
                // Subtle top-left glow like the screenshot
                Positioned(
                  left: -120,
                  top: -140,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0x220A16B8),
                          Color(0x00FFFFFF),
                        ],
                        radius: 0.75,
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    SizedBox(height: h * 0.19),

                    // Logo
                    const _SplashLogo(),

                    const SizedBox(height: 22),

                    Text(
                      'SHRI',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'YOUR SMART SAFETY COMPANION',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.9,
                      ),
                    ),

                    const Spacer(),

                    // Progress section near bottom
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: AnimatedBuilder(
                        animation: _progress,
                        builder: (context, _) {
                          final pct = (_progress.value * 100).round();
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'INITIALISING AI CORE',
                                    style: TextStyle(
                                      color: AppColors.primaryBlue.withOpacity(0.7),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$pct%',
                                    style: TextStyle(
                                      color: AppColors.primaryBlue.withOpacity(0.7),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _ProgressBar(value: _progress.value),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified_user_outlined,
                                      size: 14, color: AppColors.textMuted.withOpacity(0.8)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ENCRYPTED PROTECTION',
                                    style: TextStyle(
                                      color: AppColors.textMuted.withOpacity(0.9),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 26),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.14),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),

          // Purple sparkle bubble (top-right)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.purple, AppColors.pink],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}