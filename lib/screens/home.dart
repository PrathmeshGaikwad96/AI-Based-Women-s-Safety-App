




// // import 'package:flutter/material.dart';

// // import '../main.dart';
// // import 'alerts.dart';
// // import 'your_rights.dart';
// // import 'safety_store.dart';
// // import 'live_track.dart';
// // import 'sos_alert.dart';
// // import 'profile.dart';
// // import 'fake_call.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   int _currentIndex = 0;

// //   Future<void> _onBottomNavTap(int i) async {
// //     if (i == 1) {
// //       setState(() => _currentIndex = 1);

// //       await Navigator.of(context).push(
// //         MaterialPageRoute(builder: (_) => const AlertsScreen()),
// //       );

// //       if (!mounted) return;
// //       setState(() => _currentIndex = 0);
// //       return;
// //     }

// //     if (i == 3) {
// //       setState(() => _currentIndex = 3);

// //       await Navigator.of(context).push(
// //         MaterialPageRoute(builder: (_) => const ProfileScreen()),
// //       );

// //       if (!mounted) return;
// //       setState(() => _currentIndex = 0);
// //       return;
// //     }

// //     setState(() => _currentIndex = i);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MediaQuery(
// //       data: MediaQuery.of(context).copyWith(
// //         textScaler: const TextScaler.linear(1.0),
// //       ),
// //       child: Scaffold(
// //         backgroundColor: AppColors.bg,
// //         bottomNavigationBar: _BottomNav(
// //           currentIndex: _currentIndex,
// //           onChanged: _onBottomNavTap,
// //         ),
// //         body: SafeArea(
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 _TopHeader(
// //                   name: 'Maya',
// //                   address: '123 Safety St, Downtown',
// //                   onBellTap: () {},
// //                 ),
// //                 const SizedBox(height: 16),
// //                 const _SafetyScoreCard(
// //                   scoreText: '98%',
// //                   statusText: 'Surroundings Secure',
// //                   ringText: 'SAFE',
// //                   ringValue: 0.98,
// //                 ),
// //                 const SizedBox(height: 16),

// //                 _SosSection(
// //                   onTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const SosAlertScreen()),
// //                     );
// //                   },
// //                 ),

// //                 const SizedBox(height: 14),
// //                 const _HelperText(),
// //                 const SizedBox(height: 18),

// //                 _QuickActionsGrid(
// //                   onLiveTrackTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const LiveTrackScreen()),
// //                     );
// //                   },
// //                   onFakeCallTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const FakeCallScreen()),
// //                     );
// //                   },
// //                   onYourRightsTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const YourRightsScreen()),
// //                     );
// //                   },
// //                   onSafetyGearTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const SafetyStoreScreen()),
// //                     );
// //                   },

// //                   // New blocks (no navigation required unless you want later)
// //                   onEvidenceHubTap: () {},
// //                   onSafePlacesTap: () {},
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _TopHeader extends StatelessWidget {
// //   const _TopHeader({
// //     required this.name,
// //     required this.address,
// //     required this.onBellTap,
// //   });

// //   final String name;
// //   final String address;
// //   final VoidCallback onBellTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         Container(
// //           width: 44,
// //           height: 44,
// //           decoration: const BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: Color(0xFFF2B7A5),
// //           ),
// //           child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               RichText(
// //                 text: TextSpan(
// //                   style: const TextStyle(
// //                     fontSize: 14.5,
// //                     height: 1.1,
// //                     color: AppColors.textDark,
// //                   ),
// //                   children: [
// //                     const TextSpan(
// //                       text: 'Hello, ',
// //                       style: TextStyle(fontWeight: FontWeight.w600),
// //                     ),
// //                     TextSpan(
// //                       text: name,
// //                       style: const TextStyle(fontWeight: FontWeight.w800),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               Row(
// //                 children: [
// //                   Icon(
// //                     Icons.location_on_rounded,
// //                     size: 14,
// //                     color: AppColors.primaryBlue.withOpacity(0.95),
// //                   ),
// //                   const SizedBox(width: 4),
// //                   Flexible(
// //                     child: Text(
// //                       address,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: TextStyle(
// //                         color: AppColors.primaryBlue.withOpacity(0.95),
// //                         fontSize: 11.5,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         InkWell(
// //           onTap: onBellTap,
// //           borderRadius: BorderRadius.circular(999),
// //           child: Container(
// //             width: 42,
// //             height: 42,
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               shape: BoxShape.circle,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.06),
// //                   blurRadius: 18,
// //                   offset: const Offset(0, 10),
// //                 )
// //               ],
// //             ),
// //             child: Icon(
// //               Icons.notifications_none_rounded,
// //               size: 22,
// //               color: AppColors.textMuted.withOpacity(0.8),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _SafetyScoreCard extends StatelessWidget {
// //   const _SafetyScoreCard({
// //     required this.scoreText,
// //     required this.statusText,
// //     required this.ringText,
// //     required this.ringValue,
// //   });

// //   final String scoreText;
// //   final String statusText;
// //   final String ringText;
// //   final double ringValue;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 92,
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(24),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 22,
// //             offset: const Offset(0, 12),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'AI Safety Score',
// //                   style: TextStyle(
// //                     color: AppColors.textMuted.withOpacity(0.9),
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 3),
// //                 Text(
// //                   scoreText,
// //                   style: const TextStyle(
// //                     color: AppColors.primaryBlue,
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.w800,
// //                     height: 1.0,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 Row(
// //                   children: [
// //                     const Icon(Icons.check_circle_rounded,
// //                         size: 14, color: Color(0xFF22C55E)),
// //                     const SizedBox(width: 6),
// //                     Text(
// //                       statusText,
// //                       style: const TextStyle(
// //                         color: Color(0xFF22C55E),
// //                         fontSize: 11,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(
// //             width: 62,
// //             height: 62,
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 SizedBox(
// //                   width: 62,
// //                   height: 62,
// //                   child: CircularProgressIndicator(
// //                     value: ringValue.clamp(0, 1),
// //                     strokeWidth: 5.5,
// //                     backgroundColor: const Color(0xFFE9ECF6),
// //                     valueColor:
// //                         const AlwaysStoppedAnimation(AppColors.primaryBlue),
// //                   ),
// //                 ),
// //                 Text(
// //                   ringText,
// //                   style: const TextStyle(
// //                     color: AppColors.primaryBlue,
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w800,
// //                     letterSpacing: 0.2,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SosSection extends StatelessWidget {
// //   const _SosSection({required this.onTap});
// //   final VoidCallback onTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: GestureDetector(
// //         onTap: onTap,
// //         onLongPress: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('SOS Triggered (demo)')),
// //           );
// //         },
// //         child: SizedBox(
// //           width: 252,
// //           height: 252,
// //           child: Stack(
// //             alignment: Alignment.center,
// //             children: [
// //               Container(
// //                 width: 252,
// //                 height: 252,
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: Color(0xFFEEEFFA),
// //                 ),
// //               ),
// //               Container(
// //                 width: 214,
// //                 height: 214,
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: Color(0xFFE6E8F6),
// //                 ),
// //               ),
// //               Container(
// //                 width: 170,
// //                 height: 170,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   gradient: const LinearGradient(
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                     colors: [Color(0xFF0B1AD1), Color(0xFF0711A3)],
// //                   ),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: AppColors.primaryBlue.withOpacity(0.22),
// //                       blurRadius: 28,
// //                       offset: const Offset(0, 18),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Stack(
// //                       alignment: Alignment.center,
// //                       children: const [
// //                         Icon(Icons.wifi_rounded,
// //                             color: Colors.white, size: 30),
// //                         Padding(
// //                           padding: EdgeInsets.only(top: 18),
// //                           child: Icon(Icons.location_on_rounded,
// //                               color: Colors.white, size: 26),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 10),
// //                     const Text(
// //                       'SOS',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 22,
// //                         fontWeight: FontWeight.w800,
// //                         letterSpacing: 0.6,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       'HOLD TO ALERT',
// //                       style: TextStyle(
// //                         color: Colors.white.withOpacity(0.78),
// //                         fontSize: 9.5,
// //                         fontWeight: FontWeight.w600,
// //                         letterSpacing: 0.9,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _HelperText extends StatelessWidget {
// //   const _HelperText();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 18),
// //       child: Text(
// //         'In an emergency, hold the button to\nnotify your guardians and local\nauthorities.',
// //         textAlign: TextAlign.center,
// //         style: TextStyle(
// //           color: AppColors.textMuted.withOpacity(0.9),
// //           fontSize: 12,
// //           fontWeight: FontWeight.w500,
// //           height: 1.45,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _QuickActionsGrid extends StatelessWidget {
// //   const _QuickActionsGrid({
// //     required this.onLiveTrackTap,
// //     required this.onFakeCallTap,
// //     required this.onYourRightsTap,
// //     required this.onSafetyGearTap,
// //     this.onEvidenceHubTap,
// //     this.onSafePlacesTap,
// //   });

// //   final VoidCallback onLiveTrackTap;
// //   final VoidCallback onFakeCallTap;
// //   final VoidCallback onYourRightsTap;
// //   final VoidCallback onSafetyGearTap;

// //   // NEW (optional)
// //   final VoidCallback? onEvidenceHubTap;
// //   final VoidCallback? onSafePlacesTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return GridView(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       padding: EdgeInsets.zero,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 2,
// //         crossAxisSpacing: 14,
// //         mainAxisSpacing: 14,
// //         childAspectRatio: 1.35,
// //       ),
// //       children: [
// //         _QuickCard(
// //           icon: Icons.my_location_rounded,
// //           iconBg: const Color(0xFFE9ECFF),
// //           iconColor: AppColors.primaryBlue,
// //           title: 'Live Track',
// //           subtitle: 'Share real-time path',
// //           onTap: onLiveTrackTap,
// //         ),
// //         _QuickCard(
// //           icon: Icons.call_rounded,
// //           iconBg: const Color(0xFFFFE6F1),
// //           iconColor: AppColors.pink,
// //           title: 'Fake Call',
// //           subtitle: 'Instant exit strategy',
// //           onTap: onFakeCallTap,
// //         ),
// //         _QuickCard(
// //           icon: Icons.gavel_rounded,
// //           iconBg: const Color(0xFFE9ECFF),
// //           iconColor: AppColors.primaryBlue,
// //           title: 'Your Rights',
// //           subtitle: 'Legal AI assistance',
// //           onTap: onYourRightsTap,
// //         ),
// //         _QuickCard(
// //           icon: Icons.shopping_bag_rounded,
// //           iconBg: const Color(0xFFE9ECFF),
// //           iconColor: AppColors.primaryBlue,
// //           title: 'Safety Gear',
// //           subtitle: 'Tools and devices',
// //           onTap: onSafetyGearTap,
// //         ),

// //         // NEW: Evidence Hub
// //         _QuickCard(
// //           icon: Icons.video_camera_back_rounded,
// //           iconBg: const Color(0xFFEFEAFF),
// //           iconColor: AppColors.purple,
// //           title: 'Evidence Hub',
// //           subtitle: 'Auto-record A/V',
// //           onTap: onEvidenceHubTap,
// //         ),

// //         // NEW: Safe Places
// //         _QuickCard(
// //           icon: Icons.shield_rounded,
// //           iconBg: const Color(0xFFEFEAFF),
// //           iconColor: AppColors.purple,
// //           title: 'Safe Places',
// //           subtitle: 'Police & 24/7 help',
// //           onTap: onSafePlacesTap,
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _QuickCard extends StatelessWidget {
// //   const _QuickCard({
// //     required this.icon,
// //     required this.iconBg,
// //     required this.iconColor,
// //     required this.title,
// //     required this.subtitle,
// //     this.onTap,
// //   });

// //   final IconData icon;
// //   final Color iconBg;
// //   final Color iconColor;
// //   final String title;
// //   final String subtitle;
// //   final VoidCallback? onTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(22),
// //       child: Container(
// //         padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFF3F2F8),
// //           borderRadius: BorderRadius.circular(22),
// //           border: Border.all(color: const Color(0xFFEDEFF7)),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               width: 36,
// //               height: 36,
// //               decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
// //               child: Icon(icon, color: iconColor, size: 18),
// //             ),
// //             const Spacer(),
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                 color: AppColors.textDark,
// //                 fontSize: 13,
// //                 fontWeight: FontWeight.w800,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               subtitle,
// //               style: TextStyle(
// //                 color: AppColors.textMuted.withOpacity(0.95),
// //                 fontSize: 10.5,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _BottomNav extends StatelessWidget {
// //   const _BottomNav({
// //     required this.currentIndex,
// //     required this.onChanged,
// //   });

// //   final int currentIndex;
// //   final ValueChanged<int> onChanged;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.06),
// //             blurRadius: 24,
// //             offset: const Offset(0, -10),
// //           )
// //         ],
// //       ),
// //       child: BottomNavigationBar(
// //         currentIndex: currentIndex,
// //         onTap: onChanged,
// //         type: BottomNavigationBarType.fixed,
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         selectedItemColor: AppColors.primaryBlue,
// //         unselectedItemColor: const Color(0xFFB5B9C7),
// //         selectedLabelStyle:
// //             const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
// //         unselectedLabelStyle:
// //             const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
// //         items: const [
// //           BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
// //           BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Alerts'),
// //           BottomNavigationBarItem(icon: Icon(Icons.change_circle_rounded), label: 'Circle'),
// //           BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
// //         ],
// //       ),
// //     );
// //   }
// // }








// // import 'package:flutter/material.dart';

// // import '../main.dart';
// // import 'alerts.dart';
// // import 'your_rights.dart';
// // import 'safety_store.dart';
// // import 'live_track.dart';
// // import 'sos_alert.dart';
// // import 'profile.dart';
// // import 'fake_call.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   int _currentIndex = 0;

// //   Future<void> _onBottomNavTap(int i) async {
// //     if (i == 1) {
// //       setState(() => _currentIndex = 1);

// //       await Navigator.of(context).push(
// //         MaterialPageRoute(builder: (_) => const AlertsScreen()),
// //       );

// //       if (!mounted) return;
// //       setState(() => _currentIndex = 0);
// //       return;
// //     }

// //     if (i == 3) {
// //       setState(() => _currentIndex = 3);

// //       await Navigator.of(context).push(
// //         MaterialPageRoute(builder: (_) => const ProfileScreen()),
// //       );

// //       if (!mounted) return;
// //       setState(() => _currentIndex = 0);
// //       return;
// //     }

// //     setState(() => _currentIndex = i);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MediaQuery(
// //       data: MediaQuery.of(context).copyWith(
// //         textScaler: const TextScaler.linear(1.0),
// //       ),
// //       child: Scaffold(
// //         backgroundColor: AppColors.bg,
// //         bottomNavigationBar: _BottomNav(
// //           currentIndex: _currentIndex,
// //           onChanged: _onBottomNavTap,
// //         ),
// //         body: SafeArea(
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 _TopHeader(
// //                   name: 'Maya',
// //                   address: '123 Safety St, Downtown',
// //                   onBellTap: () {},
// //                 ),
// //                 const SizedBox(height: 16),
// //                 const _SafetyScoreCard(
// //                   scoreText: '98%',
// //                   statusText: 'Surroundings Secure',
// //                   ringText: 'SAFE',
// //                   ringValue: 0.98,
// //                 ),
// //                 const SizedBox(height: 16),

// //                 _SosSection(
// //                   onTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const SosAlertScreen()),
// //                     );
// //                   },
// //                 ),

// //                 const SizedBox(height: 14),
// //                 const _HelperText(),
// //                 const SizedBox(height: 18),

// //                 _QuickActionsGrid(
// //                   onLiveTrackTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const LiveTrackScreen()),
// //                     );
// //                   },
// //                   onFakeCallTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const FakeCallScreen()),
// //                     );
// //                   },
// //                   onYourRightsTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const YourRightsScreen()),
// //                     );
// //                   },
// //                   onSafetyGearTap: () {
// //                     Navigator.of(context).push(
// //                       MaterialPageRoute(builder: (_) => const SafetyStoreScreen()),
// //                     );
// //                   },

// //                   // These are kept as-is (now used for Government Scheme & Safe Places)
// //                   onEvidenceHubTap: () {},
// //                   onSafePlacesTap: () {},
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _TopHeader extends StatelessWidget {
// //   const _TopHeader({
// //     required this.name,
// //     required this.address,
// //     required this.onBellTap,
// //   });

// //   final String name;
// //   final String address;
// //   final VoidCallback onBellTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         // avatar
// //         Container(
// //           width: 44,
// //           height: 44,
// //           decoration: const BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: Color(0xFFF2B7A5),
// //           ),
// //           child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
// //         ),
// //         const SizedBox(width: 12),

// //         // greeting + location
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               RichText(
// //                 text: TextSpan(
// //                   style: const TextStyle(
// //                     fontSize: 14.5,
// //                     height: 1.1,
// //                     color: AppColors.textDark,
// //                   ),
// //                   children: [
// //                     const TextSpan(
// //                       text: 'Hello, ',
// //                       style: TextStyle(fontWeight: FontWeight.w600),
// //                     ),
// //                     TextSpan(
// //                       text: name,
// //                       style: const TextStyle(fontWeight: FontWeight.w800),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               Row(
// //                 children: [
// //                   Icon(Icons.location_on_rounded,
// //                       size: 14, color: AppColors.primaryBlue.withOpacity(0.95)),
// //                   const SizedBox(width: 4),
// //                   Flexible(
// //                     child: Text(
// //                       address,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: TextStyle(
// //                         color: AppColors.primaryBlue.withOpacity(0.95),
// //                         fontSize: 11.5,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),

// //         const SizedBox(width: 12),

// //         // bell
// //         InkWell(
// //           onTap: onBellTap,
// //           borderRadius: BorderRadius.circular(999),
// //           child: Container(
// //             width: 42,
// //             height: 42,
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               shape: BoxShape.circle,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.06),
// //                   blurRadius: 18,
// //                   offset: const Offset(0, 10),
// //                 )
// //               ],
// //             ),
// //             child: Icon(Icons.notifications_none_rounded,
// //                 size: 22, color: AppColors.textMuted.withOpacity(0.8)),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _SafetyScoreCard extends StatelessWidget {
// //   const _SafetyScoreCard({
// //     required this.scoreText,
// //     required this.statusText,
// //     required this.ringText,
// //     required this.ringValue,
// //   });

// //   final String scoreText;
// //   final String statusText;
// //   final String ringText;
// //   final double ringValue;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 92,
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(24),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 22,
// //             offset: const Offset(0, 12),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           // left texts
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'AI Safety Score',
// //                   style: TextStyle(
// //                     color: AppColors.textMuted.withOpacity(0.9),
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 3),
// //                 Text(
// //                   scoreText,
// //                   style: const TextStyle(
// //                     color: AppColors.primaryBlue,
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.w800,
// //                     height: 1.0,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 Row(
// //                   children: [
// //                     const Icon(Icons.check_circle_rounded,
// //                         size: 14, color: Color(0xFF22C55E)),
// //                     const SizedBox(width: 6),
// //                     Text(
// //                       statusText,
// //                       style: const TextStyle(
// //                         color: Color(0xFF22C55E),
// //                         fontSize: 11,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),

// //           // ring
// //           SizedBox(
// //             width: 62,
// //             height: 62,
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 SizedBox(
// //                   width: 62,
// //                   height: 62,
// //                   child: CircularProgressIndicator(
// //                     value: ringValue.clamp(0, 1),
// //                     strokeWidth: 5.5,
// //                     backgroundColor: const Color(0xFFE9ECF6),
// //                     valueColor:
// //                         const AlwaysStoppedAnimation(AppColors.primaryBlue),
// //                   ),
// //                 ),
// //                 Text(
// //                   ringText,
// //                   style: const TextStyle(
// //                     color: AppColors.primaryBlue,
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w800,
// //                     letterSpacing: 0.2,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SosSection extends StatelessWidget {
// //   const _SosSection({required this.onTap});
// //   final VoidCallback onTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: GestureDetector(
// //         onTap: onTap,
// //         onLongPress: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('SOS Triggered (demo)')),
// //           );
// //         },
// //         child: SizedBox(
// //           width: 252,
// //           height: 252,
// //           child: Stack(
// //             alignment: Alignment.center,
// //             children: [
// //               // outer ring
// //               Container(
// //                 width: 252,
// //                 height: 252,
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: Color(0xFFEEEFFA),
// //                 ),
// //               ),
// //               // mid ring
// //               Container(
// //                 width: 214,
// //                 height: 214,
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: Color(0xFFE6E8F6),
// //                 ),
// //               ),
// //               // inner blue button
// //               Container(
// //                 width: 170,
// //                 height: 170,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   gradient: const LinearGradient(
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                     colors: [Color(0xFF0B1AD1), Color(0xFF0711A3)],
// //                   ),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: AppColors.primaryBlue.withOpacity(0.22),
// //                       blurRadius: 28,
// //                       offset: const Offset(0, 18),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     // icon stack (wifi-ish + location)
// //                     Stack(
// //                       alignment: Alignment.center,
// //                       children: const [
// //                         Icon(Icons.wifi_rounded, color: Colors.white, size: 30),
// //                         Padding(
// //                           padding: EdgeInsets.only(top: 18),
// //                           child: Icon(Icons.location_on_rounded,
// //                               color: Colors.white, size: 26),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 10),
// //                     const Text(
// //                       'SOS',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 22,
// //                         fontWeight: FontWeight.w800,
// //                         letterSpacing: 0.6,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       'HOLD TO ALERT',
// //                       style: TextStyle(
// //                         color: Colors.white.withOpacity(0.78),
// //                         fontSize: 9.5,
// //                         fontWeight: FontWeight.w600,
// //                         letterSpacing: 0.9,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _HelperText extends StatelessWidget {
// //   const _HelperText();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 18),
// //       child: Text(
// //         'In an emergency, hold the button to\nnotify your guardians and local\nauthorities.',
// //         textAlign: TextAlign.center,
// //         style: TextStyle(
// //           color: AppColors.textMuted.withOpacity(0.9),
// //           fontSize: 12,
// //           fontWeight: FontWeight.w500,
// //           height: 1.45,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _QuickActionsGrid extends StatelessWidget {
// //   const _QuickActionsGrid({
// //     required this.onLiveTrackTap,
// //     required this.onFakeCallTap,
// //     required this.onYourRightsTap,
// //     required this.onSafetyGearTap,
// //     this.onEvidenceHubTap,
// //     this.onSafePlacesTap,
// //   });

// //   final VoidCallback onLiveTrackTap;
// //   final VoidCallback onFakeCallTap;
// //   final VoidCallback onYourRightsTap;
// //   final VoidCallback onSafetyGearTap;

// //   // Kept as-is (used for Government Scheme)
// //   final VoidCallback? onEvidenceHubTap;
// //   final VoidCallback? onSafePlacesTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return GridView(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       padding: EdgeInsets.zero,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 2,
// //         crossAxisSpacing: 14,
// //         mainAxisSpacing: 14,
// //         childAspectRatio: 1.35,
// //       ),
// //       children: [
// //         _QuickCard(
// //           icon: Icons.my_location_rounded,
// //           iconBg: const Color(0xFFE9ECFF),
// //           iconColor: AppColors.primaryBlue,
// //           title: 'Live Track',
// //           subtitle: 'Share real-time path',
// //           onTap: onLiveTrackTap,
// //         ),
// //         _QuickCard(
// //           icon: Icons.call_rounded,
// //           iconBg: const Color(0xFFFFE6F1),
// //           iconColor: AppColors.pink,
// //           title: 'Fake Call',
// //           subtitle: 'Instant exit strategy',
// //           onTap: onFakeCallTap,
// //         ),
// //         _QuickCard(
// //           icon: Icons.gavel_rounded,
// //           iconBg: const Color(0xFFE9ECFF),
// //           iconColor: AppColors.primaryBlue,
// //           title: 'Your Rights',
// //           subtitle: 'Legal AI assistance',
// //           onTap: onYourRightsTap,
// //         ),
// //         _QuickCard(
// //           icon: Icons.shopping_bag_rounded,
// //           iconBg: const Color(0xFFE9ECFF),
// //           iconColor: AppColors.primaryBlue,
// //           title: 'Safety Gear',
// //           subtitle: 'Tools and devices',
// //           onTap: onSafetyGearTap,
// //         ),

// //         // UPDATED: Evidence Hub -> Government Scheme (everything else unchanged)
// //         _QuickCard(
// //           icon: Icons.account_balance_rounded,
// //           iconBg: const Color(0xFFEFEAFF),
// //           iconColor: AppColors.purple,
// //           title: 'Government Scheme',
// //           subtitle: 'Programs & support',
// //           onTap: onEvidenceHubTap,
// //         ),

// //         // Safe Places
// //         _QuickCard(
// //           icon: Icons.shield_rounded,
// //           iconBg: const Color(0xFFEFEAFF),
// //           iconColor: AppColors.purple,
// //           title: 'Safe Places',
// //           subtitle: 'Police & 24/7 help',
// //           onTap: onSafePlacesTap,
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _QuickCard extends StatelessWidget {
// //   const _QuickCard({
// //     required this.icon,
// //     required this.iconBg,
// //     required this.iconColor,
// //     required this.title,
// //     required this.subtitle,
// //     this.onTap,
// //   });

// //   final IconData icon;
// //   final Color iconBg;
// //   final Color iconColor;
// //   final String title;
// //   final String subtitle;
// //   final VoidCallback? onTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(22),
// //       child: Container(
// //         padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFF3F2F8),
// //           borderRadius: BorderRadius.circular(22),
// //           border: Border.all(color: const Color(0xFFEDEFF7)),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               width: 36,
// //               height: 36,
// //               decoration: BoxDecoration(
// //                 color: iconBg,
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(icon, color: iconColor, size: 18),
// //             ),
// //             const Spacer(),
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                 color: AppColors.textDark,
// //                 fontSize: 13,
// //                 fontWeight: FontWeight.w800,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               subtitle,
// //               style: TextStyle(
// //                 color: AppColors.textMuted.withOpacity(0.95),
// //                 fontSize: 10.5,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _BottomNav extends StatelessWidget {
// //   const _BottomNav({
// //     required this.currentIndex,
// //     required this.onChanged,
// //   });

// //   final int currentIndex;
// //   final ValueChanged<int> onChanged;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.06),
// //             blurRadius: 24,
// //             offset: const Offset(0, -10),
// //           )
// //         ],
// //       ),
// //       child: BottomNavigationBar(
// //         currentIndex: currentIndex,
// //         onTap: onChanged,
// //         type: BottomNavigationBarType.fixed,
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         selectedItemColor: AppColors.primaryBlue,
// //         unselectedItemColor: const Color(0xFFB5B9C7),
// //         selectedLabelStyle:
// //             const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
// //         unselectedLabelStyle:
// //             const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
// //         items: const [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.home_rounded),
// //             label: 'Home',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.notifications_rounded),
// //             label: 'Alerts',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.change_circle_rounded),
// //             label: 'Circle',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.person_rounded),
// //             label: 'Profile',
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// import '../main.dart';
// import 'alerts.dart';
// import 'your_rights.dart';
// import 'safety_store.dart';
// import 'live_track.dart';
// import 'sos_alert.dart';
// import 'profile.dart';
// import 'fake_call.dart';
// import 'government_scheme.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;

//   Future<void> _onBottomNavTap(int i) async {
//     if (i == 1) {
//       setState(() => _currentIndex = 1);

//       await Navigator.of(context).push(
//         MaterialPageRoute(builder: (_) => const AlertsScreen()),
//       );

//       if (!mounted) return;
//       setState(() => _currentIndex = 0);
//       return;
//     }

//     if (i == 3) {
//       setState(() => _currentIndex = 3);

//       await Navigator.of(context).push(
//         MaterialPageRoute(builder: (_) => const ProfileScreen()),
//       );

//       if (!mounted) return;
//       setState(() => _currentIndex = 0);
//       return;
//     }

//     setState(() => _currentIndex = i);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//         textScaler: const TextScaler.linear(1.0),
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.bg,
//         bottomNavigationBar: _BottomNav(
//           currentIndex: _currentIndex,
//           onChanged: _onBottomNavTap,
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _TopHeader(
//                   name: 'Maya',
//                   address: '123 Safety St, Downtown',
//                   onBellTap: () {},
//                 ),
//                 const SizedBox(height: 16),
//                 const _SafetyScoreCard(
//                   scoreText: '98%',
//                   statusText: 'Surroundings Secure',
//                   ringText: 'SAFE',
//                   ringValue: 0.98,
//                 ),
//                 const SizedBox(height: 16),

//                 _SosSection(
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const SosAlertScreen()),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 14),
//                 const _HelperText(),
//                 const SizedBox(height: 18),

//                 _QuickActionsGrid(
//                   onLiveTrackTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const LiveTrackScreen()),
//                     );
//                   },
//                   onFakeCallTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const FakeCallScreen()),
//                     );
//                   },
//                   onYourRightsTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const YourRightsScreen()),
//                     );
//                   },
//                   onSafetyGearTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const SafetyStoreScreen()),
//                     );
//                   },

//                   // Government Scheme navigation
//                   onEvidenceHubTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const GovernmentSchemeScreen()),
//                     );
//                   },

//                   // keep as-is
//                   onSafePlacesTap: () {},
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /* ---- BELOW: unchanged widgets from your current home.dart (TopHeader, SafetyScoreCard, SOS, HelperText, QuickActionsGrid, QuickCard, BottomNav) ---- */

// class _TopHeader extends StatelessWidget {
//   const _TopHeader({
//     required this.name,
//     required this.address,
//     required this.onBellTap,
//   });

//   final String name;
//   final String address;
//   final VoidCallback onBellTap;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 44,
//           height: 44,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Color(0xFFF2B7A5),
//           ),
//           child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RichText(
//                 text: TextSpan(
//                   style: const TextStyle(
//                     fontSize: 14.5,
//                     height: 1.1,
//                     color: AppColors.textDark,
//                   ),
//                   children: [
//                     const TextSpan(
//                       text: 'Hello, ',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     TextSpan(
//                       text: name,
//                       style: const TextStyle(fontWeight: FontWeight.w800),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Icon(Icons.location_on_rounded,
//                       size: 14, color: AppColors.primaryBlue.withOpacity(0.95)),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       address,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: AppColors.primaryBlue.withOpacity(0.95),
//                         fontSize: 11.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         InkWell(
//           onTap: onBellTap,
//           borderRadius: BorderRadius.circular(999),
//           child: Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 18,
//                   offset: const Offset(0, 10),
//                 )
//               ],
//             ),
//             child: Icon(Icons.notifications_none_rounded,
//                 size: 22, color: AppColors.textMuted.withOpacity(0.8)),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SafetyScoreCard extends StatelessWidget {
//   const _SafetyScoreCard({
//     required this.scoreText,
//     required this.statusText,
//     required this.ringText,
//     required this.ringValue,
//   });

//   final String scoreText;
//   final String statusText;
//   final String ringText;
//   final double ringValue;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 92,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 22,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'AI Safety Score',
//                   style: TextStyle(
//                     color: AppColors.textMuted.withOpacity(0.9),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   scoreText,
//                   style: const TextStyle(
//                     color: AppColors.primaryBlue,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                     height: 1.0,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(Icons.check_circle_rounded,
//                         size: 14, color: Color(0xFF22C55E)),
//                     const SizedBox(width: 6),
//                     Text(
//                       statusText,
//                       style: const TextStyle(
//                         color: Color(0xFF22C55E),
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 62,
//             height: 62,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   width: 62,
//                   height: 62,
//                   child: CircularProgressIndicator(
//                     value: ringValue.clamp(0, 1),
//                     strokeWidth: 5.5,
//                     backgroundColor: const Color(0xFFE9ECF6),
//                     valueColor:
//                         const AlwaysStoppedAnimation(AppColors.primaryBlue),
//                   ),
//                 ),
//                 Text(
//                   ringText,
//                   style: const TextStyle(
//                     color: AppColors.primaryBlue,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SosSection extends StatelessWidget {
//   const _SosSection({required this.onTap});
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: onTap,
//         onLongPress: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('SOS Triggered (demo)')),
//           );
//         },
//         child: SizedBox(
//           width: 252,
//           height: 252,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 width: 252,
//                 height: 252,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color(0xFFEEEFFA),
//                 ),
//               ),
//               Container(
//                 width: 214,
//                 height: 214,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color(0xFFE6E8F6),
//                 ),
//               ),
//               Container(
//                 width: 170,
//                 height: 170,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Color(0xFF0B1AD1), Color(0xFF0711A3)],
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primaryBlue.withOpacity(0.22),
//                       blurRadius: 28,
//                       offset: const Offset(0, 18),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Stack(
//                       alignment: Alignment.center,
//                       children: const [
//                         Icon(Icons.wifi_rounded, color: Colors.white, size: 30),
//                         Padding(
//                           padding: EdgeInsets.only(top: 18),
//                           child: Icon(Icons.location_on_rounded,
//                               color: Colors.white, size: 26),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'SOS',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: 0.6,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'HOLD TO ALERT',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.78),
//                         fontSize: 9.5,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.9,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _HelperText extends StatelessWidget {
//   const _HelperText();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       child: Text(
//         'In an emergency, hold the button to\nnotify your guardians and local\nauthorities.',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: AppColors.textMuted.withOpacity(0.9),
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           height: 1.45,
//         ),
//       ),
//     );
//   }
// }

// class _QuickActionsGrid extends StatelessWidget {
//   const _QuickActionsGrid({
//     required this.onLiveTrackTap,
//     required this.onFakeCallTap,
//     required this.onYourRightsTap,
//     required this.onSafetyGearTap,
//     this.onEvidenceHubTap,
//     this.onSafePlacesTap,
//   });

//   final VoidCallback onLiveTrackTap;
//   final VoidCallback onFakeCallTap;
//   final VoidCallback onYourRightsTap;
//   final VoidCallback onSafetyGearTap;

//   final VoidCallback? onEvidenceHubTap;
//   final VoidCallback? onSafePlacesTap;

//   @override
//   Widget build(BuildContext context) {
//     return GridView(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.zero,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 14,
//         mainAxisSpacing: 14,
//         childAspectRatio: 1.35,
//       ),
//       children: [
//         _QuickCard(
//           icon: Icons.my_location_rounded,
//           iconBg: const Color(0xFFE9ECFF),
//           iconColor: AppColors.primaryBlue,
//           title: 'Live Track',
//           subtitle: 'Share real-time path',
//           onTap: onLiveTrackTap,
//         ),
//         _QuickCard(
//           icon: Icons.call_rounded,
//           iconBg: const Color(0xFFFFE6F1),
//           iconColor: AppColors.pink,
//           title: 'Fake Call',
//           subtitle: 'Instant exit strategy',
//           onTap: onFakeCallTap,
//         ),
//         _QuickCard(
//           icon: Icons.gavel_rounded,
//           iconBg: const Color(0xFFE9ECFF),
//           iconColor: AppColors.primaryBlue,
//           title: 'Your Rights',
//           subtitle: 'Legal AI assistance',
//           onTap: onYourRightsTap,
//         ),
//         _QuickCard(
//           icon: Icons.shopping_bag_rounded,
//           iconBg: const Color(0xFFE9ECFF),
//           iconColor: AppColors.primaryBlue,
//           title: 'Safety Gear',
//           subtitle: 'Tools and devices',
//           onTap: onSafetyGearTap,
//         ),
//         _QuickCard(
//           icon: Icons.account_balance_rounded,
//           iconBg: const Color(0xFFEFEAFF),
//           iconColor: AppColors.purple,
//           title: 'Government Scheme',
//           subtitle: 'Programs & support',
//           onTap: onEvidenceHubTap,
//         ),
//         _QuickCard(
//           icon: Icons.shield_rounded,
//           iconBg: const Color(0xFFEFEAFF),
//           iconColor: AppColors.purple,
//           title: 'Safe Places',
//           subtitle: 'Police & 24/7 help',
//           onTap: onSafePlacesTap,
//         ),
//       ],
//     );
//   }
// }

// class _QuickCard extends StatelessWidget {
//   const _QuickCard({
//     required this.icon,
//     required this.iconBg,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     this.onTap,
//   });

//   final IconData icon;
//   final Color iconBg;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(22),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF3F2F8),
//           borderRadius: BorderRadius.circular(22),
//           border: Border.all(color: const Color(0xFFEDEFF7)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
//               child: Icon(icon, color: iconColor, size: 18),
//             ),
//             const Spacer(),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: AppColors.textDark,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 color: AppColors.textMuted.withOpacity(0.95),
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _BottomNav extends StatelessWidget {
//   const _BottomNav({
//     required this.currentIndex,
//     required this.onChanged,
//   });

//   final int currentIndex;
//   final ValueChanged<int> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 24,
//             offset: const Offset(0, -10),
//           )
//         ],
//       ),
//       child: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: onChanged,
//         type: BottomNavigationBarType.fixed,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         selectedItemColor: AppColors.primaryBlue,
//         unselectedItemColor: const Color(0xFFB5B9C7),
//         selectedLabelStyle:
//             const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
//         unselectedLabelStyle:
//             const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Alerts'),
//           BottomNavigationBarItem(icon: Icon(Icons.change_circle_rounded), label: 'Circle'),
//           BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../main.dart';
import 'alerts.dart';
import 'your_rights.dart';
import 'safety_store.dart';
import 'live_track.dart';
import 'sos_alert.dart';
import 'profile.dart';
import 'fake_call.dart';
import 'government_scheme.dart';
import 'ai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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

    // NEW: Circle -> AI Screen
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
                _TopHeader(
                  name: 'Maya',
                  address: '123 Safety St, Downtown',
                  onBellTap: () {},
                ),
                const SizedBox(height: 16),
                const _SafetyScoreCard(
                  scoreText: '98%',
                  statusText: 'Surroundings Secure',
                  ringText: 'SAFE',
                  ringValue: 0.98,
                ),
                const SizedBox(height: 16),

                _SosSection(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SosAlertScreen()),
                    );
                  },
                ),

                const SizedBox(height: 14),
                const _HelperText(),
                const SizedBox(height: 18),

                _QuickActionsGrid(
                  onLiveTrackTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LiveTrackScreen()),
                    );
                  },
                  onFakeCallTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FakeCallScreen()),
                    );
                  },
                  onYourRightsTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const YourRightsScreen()),
                    );
                  },
                  onSafetyGearTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SafetyStoreScreen()),
                    );
                  },
                  onEvidenceHubTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GovernmentSchemeScreen()),
                    );
                  },
                  onSafePlacesTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* --- below is unchanged from your current home.dart --- */

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
            color: Color(0xFFF2B7A5),
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
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
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 14, color: AppColors.primaryBlue.withOpacity(0.95)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primaryBlue.withOpacity(0.95),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
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
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(Icons.notifications_none_rounded,
                size: 22, color: AppColors.textMuted.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}

class _SafetyScoreCard extends StatelessWidget {
  const _SafetyScoreCard({
    required this.scoreText,
    required this.statusText,
    required this.ringText,
    required this.ringValue,
  });

  final String scoreText;
  final String statusText;
  final String ringText;
  final double ringValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
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
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  scoreText,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 14, color: Color(0xFF22C55E)),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 62,
            height: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 62,
                  height: 62,
                  child: CircularProgressIndicator(
                    value: ringValue.clamp(0, 1),
                    strokeWidth: 5.5,
                    backgroundColor: const Color(0xFFE9ECF6),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primaryBlue),
                  ),
                ),
                Text(
                  ringText,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SosSection extends StatelessWidget {
  const _SosSection({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SOS Triggered (demo)')),
          );
        },
        child: SizedBox(
          width: 252,
          height: 252,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 252,
                height: 252,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEEEFFA),
                ),
              ),
              Container(
                width: 214,
                height: 214,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE6E8F6),
                ),
              ),
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0B1AD1), Color(0xFF0711A3)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.22),
                      blurRadius: 28,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(Icons.wifi_rounded, color: Colors.white, size: 30),
                        Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Icon(Icons.location_on_rounded,
                              color: Colors.white, size: 26),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'HOLD TO ALERT',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelperText extends StatelessWidget {
  const _HelperText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        'In an emergency, hold the button to\nnotify your guardians and local\nauthorities.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textMuted.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.onLiveTrackTap,
    required this.onFakeCallTap,
    required this.onYourRightsTap,
    required this.onSafetyGearTap,
    this.onEvidenceHubTap,
    this.onSafePlacesTap,
  });

  final VoidCallback onLiveTrackTap;
  final VoidCallback onFakeCallTap;
  final VoidCallback onYourRightsTap;
  final VoidCallback onSafetyGearTap;

  final VoidCallback? onEvidenceHubTap;
  final VoidCallback? onSafePlacesTap;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.35,
      ),
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
          subtitle: 'Tools and devices',
          onTap: onSafetyGearTap,
        ),
        _QuickCard(
          icon: Icons.account_balance_rounded,
          iconBg: const Color(0xFFEFEAFF),
          iconColor: AppColors.purple,
          title: 'Government Scheme',
          subtitle: 'Programs & support',
          onTap: onEvidenceHubTap,
        ),
        _QuickCard(
          icon: Icons.shield_rounded,
          iconBg: const Color(0xFFEFEAFF),
          iconColor: AppColors.purple,
          title: 'Safe Places',
          subtitle: 'Police & 24/7 help',
          onTap: onSafePlacesTap,
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
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F2F8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFEDEFF7)),
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
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textMuted.withOpacity(0.95),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
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
        selectedLabelStyle:
            const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.change_circle_rounded), label: 'Circle'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}