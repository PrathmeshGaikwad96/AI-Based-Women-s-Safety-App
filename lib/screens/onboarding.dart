// import 'package:basic/main.dart';
// import 'package:flutter/material.dart';


// /// ---------- Screen 2: Onboarding ----------
// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Top bar
//               Row(
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         color: AppColors.primaryBlue,
//                         letterSpacing: 0.2,
//                       ),
//                       children: const [
//                         TextSpan(text: 'SHRI'),
//                         TextSpan(
//                           text: '.',
//                           style: TextStyle(
//                             color: AppColors.pink,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     'Skip',
//                     style: TextStyle(
//                       color: AppColors.textMuted,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 14),

//               // Map card with overlay chips
//               const _MapCard(),

//               const SizedBox(height: 22),

//               Text(
//                 'Predictive Safety at\nYour Fingertips',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.textDark,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                   height: 1.18,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'SHRI uses AI to analyze real-time data and\nneighborhood trends, helping you choose\nthe safest routes and stay informed.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.textMuted,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   height: 1.5,
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Page indicator (single pill like screenshot)
//               Container(
//                 width: 26,
//                 height: 5,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryBlue,
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//               ),

//               const Spacer(),

//               // Get Started button -> Navigation using button (as you requested)
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(28),
//                   onTap: () {
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (_) => const HomeScreen()),
//                     );
//                   },
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryBlue,
//                       borderRadius: BorderRadius.circular(28),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primaryBlue.withOpacity(0.22),
//                           blurRadius: 22,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Get Started',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Simple target screen for button navigation
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.bg,
//         title: const Text(
//           'Home',
//           style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700),
//         ),
//         iconTheme: const IconThemeData(color: AppColors.textDark),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to SHRI',
//           style: TextStyle(
//             color: AppColors.textDark,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _MapCard extends StatelessWidget {
//   const _MapCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 260,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F7FD),
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28),
//         child: Stack(
//           children: [
//             // Map background - replace assets/map.png with your exact screenshot for perfect match.
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/map.png',
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) {
//                   // Fallback if asset missing
//                   return Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFFEFF2FB), Color(0xFFF7F8FC)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Center(
//                       child: Icon(Icons.map_outlined,
//                           color: AppColors.textMuted.withOpacity(0.45), size: 44),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Soft white overlay like screenshot
//             Positioned.fill(
//               child: Container(color: Colors.white.withOpacity(0.32)),
//             ),

//             // Main "Safest Route Found" card
//             Positioned(
//               left: 42,
//               right: 42,
//               top: 46,
//               child: _GlassCard(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 28,
//                       height: 28,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE9ECFF),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(Icons.shield_rounded,
//                           size: 16, color: AppColors.primaryBlue),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'AI OPTIMIZED PATH',
//                             style: TextStyle(
//                               color: AppColors.textMuted,
//                               fontSize: 9.5,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 0.8,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             'Safest Route Found',
//                             style: TextStyle(
//                               color: AppColors.textDark,
//                               fontSize: 12.5,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: 22,
//                       height: 22,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFEAF9F1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.check,
//                           size: 14, color: AppColors.success),
//                     )
//                   ],
//                 ),
//               ),
//             ),

//             // Recent alert chip
//             Positioned(
//               left: 70,
//               right: 70,
//               top: 116,
//               child: _GlassCard(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 22,
//                       height: 22,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFFFEDF5),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.campaign_outlined,
//                           size: 14, color: AppColors.pink),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Recent alert nearby',
//                       style: TextStyle(
//                         color: AppColors.textDark,
//                         fontSize: 11.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // High foot traffic chip
//             Positioned(
//               left: 26,
//               top: 165,
//               child: _GlassCard(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 22,
//                       height: 22,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFEFF2FF),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.groups_2_outlined,
//                           size: 14, color: AppColors.primaryBlue.withOpacity(0.9)),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'High foot traffic area',
//                       style: TextStyle(
//                         color: AppColors.textDark,
//                         fontSize: 11.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Red floating button with asterisk
//             Positioned(
//               right: 28,
//               bottom: 34,
//               child: Container(
//                 width: 52,
//                 height: 52,
//                 decoration: BoxDecoration(
//                   color: AppColors.danger,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.danger.withOpacity(0.25),
//                       blurRadius: 18,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     '*',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontWeight: FontWeight.w800,
//                       height: 1,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _GlassCard extends StatelessWidget {
//   const _GlassCard({required this.child, this.padding});
//   final Widget child;
//   final EdgeInsets? padding;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: padding ?? const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.90),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.7)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
import 'package:basic/main.dart';
import 'package:flutter/material.dart';


import 'home.dart';

/// ---------- Screen 2: Onboarding ----------
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top bar
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                        letterSpacing: 0.2,
                      ),
                      children: const [
                        TextSpan(text: 'SHRI'),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: AppColors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Map card with overlay chips
              const _MapCard(),

              const SizedBox(height: 22),

              Text(
                'Predictive Safety at\nYour Fingertips',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'SHRI uses AI to analyze real-time data and\nneighborhood trends, helping you choose\nthe safest routes and stay informed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              // Page indicator (single pill like screenshot)
              Container(
                width: 26,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              const Spacer(),

              // Get Started button -> Navigates to HomeScreen (from home.dart)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.22),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

class _MapCard extends StatelessWidget {
  const _MapCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FD),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Map background - replace assets/map.png with your exact screenshot for perfect match.
            Positioned.fill(
              child: Image.asset(
                'assets/map.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  // Fallback if asset missing
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEFF2FB), Color(0xFFF7F8FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.map_outlined,
                        color: Color(0xFF7E8497),
                        size: 44,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Soft white overlay like screenshot
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.32)),
            ),

            // Main "Safest Route Found" card
            Positioned(
              left: 42,
              right: 42,
              top: 46,
              child: _GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9ECFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        size: 16,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AI OPTIMIZED PATH',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Safest Route Found',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF9F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 14, color: AppColors.success),
                    )
                  ],
                ),
              ),
            ),

            // Recent alert chip
            Positioned(
              left: 70,
              right: 70,
              top: 116,
              child: _GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEDF5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        size: 14,
                        color: AppColors.pink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recent alert nearby',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // High foot traffic chip
            Positioned(
              left: 26,
              top: 165,
              child: _GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.groups_2_outlined,
                        size: 14,
                        color: AppColors.primaryBlue.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'High foot traffic area',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Red floating button with asterisk
            Positioned(
              right: 28,
              bottom: 34,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.danger.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '*',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.padding});
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}