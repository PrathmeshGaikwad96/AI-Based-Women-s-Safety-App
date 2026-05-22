// import 'package:flutter/material.dart';
// import '../main.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _aiSentinel = true;
//   bool _shadowTracking = false;

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).padding.bottom;

//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//         textScaler: const TextScaler.linear(1.0),
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.bg,
//         body: SafeArea(
//           bottom: false,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Top bar
//                 Row(
//                   children: [
//                     _TopCircleButton(
//                       icon: Icons.chevron_left_rounded,
//                       onTap: () => Navigator.of(context).pop(),
//                     ),
//                     const Spacer(),
//                     const Text(
//                       'Profile',
//                       style: TextStyle(
//                         color: AppColors.textDark,
//                         fontSize: 15.5,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     const Spacer(),
//                     _TopCircleButton(
//                       icon: Icons.more_horiz_rounded,
//                       onTap: () {},
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 18),

//                 // Avatar
//                 Center(
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         width: 86,
//                         height: 86,
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFD8B38A),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Center(
//                           child: Icon(Icons.person_rounded,
//                               size: 48, color: Color(0xFF2A2A2A)),
//                         ),
//                       ),
//                       Positioned(
//                         right: -2,
//                         bottom: -2,
//                         child: Container(
//                           width: 26,
//                           height: 26,
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryBlue,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: AppColors.bg, width: 3),
//                           ),
//                           child: const Icon(Icons.check_rounded,
//                               size: 14, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 14),

//                 const Center(
//                   child: Text(
//                     'Gauri Adsul',
//                     style: TextStyle(
//                       color: AppColors.textDark,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 Center(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFEFF2FF),
//                       borderRadius: BorderRadius.circular(999),
//                       border: Border.all(color: const Color(0xFFE3E7FF)),
//                     ),
//                     child: Text(
//                       'AI-Safe Member since 2023',
//                       style: TextStyle(
//                         color: AppColors.primaryBlue.withOpacity(0.95),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 Center(
//                   child: SizedBox(
//                     height: 34,
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryBlue,
//                         borderRadius: BorderRadius.circular(999),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.primaryBlue.withOpacity(0.18),
//                             blurRadius: 18,
//                             offset: const Offset(0, 12),
//                           ),
//                         ],
//                       ),
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(999),
//                         onTap: () {},
//                         child: const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 18),
//                           child: Center(
//                             child: Text(
//                               'Edit Profile',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 // Emergency Contacts
//                 Row(
//                   children: [
//                     const Text(
//                       'Emergency Contacts',
//                       style: TextStyle(
//                         color: AppColors.textDark,
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       'Add New',
//                       style: TextStyle(
//                         color: AppColors.primaryBlue.withOpacity(0.95),
//                         fontSize: 11,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),

//                 Container(
//                   padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(color: const Color(0xFFE9ECF6)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.03),
//                         blurRadius: 22,
//                         offset: const Offset(0, 12),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 42,
//                         height: 42,
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFF2B7A5),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Center(
//                           child: Icon(Icons.person_rounded,
//                               size: 22, color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Suresh Adsul',
//                               style: TextStyle(
//                                 color: AppColors.textDark,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Father • Primary Contact',
//                               style: TextStyle(
//                                 color: AppColors.textMuted.withOpacity(0.9),
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       _MiniCircleAction(
//                         icon: Icons.call_rounded,
//                         color: AppColors.primaryBlue,
//                         bg: const Color(0xFFEFF2FF),
//                         onTap: () {},
//                       ),
//                       const SizedBox(width: 8),
//                       _MiniCircleAction(
//                         icon: Icons.edit_rounded,
//                         color: AppColors.textMuted.withOpacity(0.9),
//                         bg: const Color(0xFFF2F4FA),
//                         onTap: () {},
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 // AI Safety Features
//                 const Text(
//                   'AI Safety Features',
//                   style: TextStyle(
//                     color: AppColors.textDark,
//                     fontSize: 12.5,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 Container(
//                   padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(color: const Color(0xFFE9ECF6)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.03),
//                         blurRadius: 22,
//                         offset: const Offset(0, 12),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       _SwitchRow(
//                         iconBg: const Color(0xFFEFF2FF),
//                         iconColor: AppColors.primaryBlue,
//                         icon: Icons.shield_rounded,
//                         title: 'AI Sentinel Monitoring',
//                         subtitle: 'Auto-detect distress signals',
//                         value: _aiSentinel,
//                         onChanged: (v) => setState(() => _aiSentinel = v),
//                       ),
//                       const SizedBox(height: 10),
//                       Divider(height: 1, thickness: 1, color: const Color(0xFFE9ECF6)),
//                       const SizedBox(height: 10),
//                       _SwitchRow(
//                         iconBg: const Color(0xFFFFE6F1),
//                         iconColor: AppColors.pink,
//                         icon: Icons.location_on_rounded,
//                         title: 'Shadow Tracking',
//                         subtitle: 'Discrete location broadcast',
//                         value: _shadowTracking,
//                         onChanged: (v) => setState(() => _shadowTracking = v),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 // Account & Privacy
//                 const Text(
//                   'Account & Privacy',
//                   style: TextStyle(
//                     color: AppColors.textDark,
//                     fontSize: 12.5,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(color: const Color(0xFFE9ECF6)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.03),
//                         blurRadius: 22,
//                         offset: const Offset(0, 12),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: const [
//                       _AccountTile(
//                         icon: Icons.lock_outline_rounded,
//                         title: 'Privacy Settings',
//                       ),
//                       _TileDivider(),
//                       _AccountTile(
//                         icon: Icons.verified_user_outlined,
//                         title: 'Identity Verification',
//                         trailingBadgeText: 'ACTIVE',
//                         trailingBadgeColor: Color(0xFF23C16B),
//                         trailingBadgeBg: Color(0xFFEAF9F1),
//                       ),
//                       _TileDivider(),
//                       _AccountTile(
//                         icon: Icons.help_outline_rounded,
//                         title: 'Help & Support',
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Logout
//                 SizedBox(
//                   height: 46,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(14),
//                     onTap: () {},
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(color: const Color(0xFFE9ECF6)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.logout_rounded,
//                               size: 18, color: Color(0xFFFF3B30)),
//                           SizedBox(width: 10),
//                           Text(
//                             'Logout Account',
//                             style: TextStyle(
//                               color: Color(0xFFFF3B30),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 14),

//                 Center(
//                   child: Text(
//                     'SHRI App Version 4.2.0 • Secured by SHRI AI',
//                     style: TextStyle(
//                       color: AppColors.textMuted.withOpacity(0.75),
//                       fontSize: 9.5,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: bottomInset + 10),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TopCircleButton extends StatelessWidget {
//   const _TopCircleButton({required this.icon, required this.onTap});
//   final IconData icon;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(999),
//       onTap: onTap,
//       child: Container(
//         width: 38,
//         height: 38,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           border: Border.all(color: const Color(0xFFE9ECF6)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 18,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Icon(icon, size: 22, color: AppColors.textDark.withOpacity(0.9)),
//       ),
//     );
//   }
// }

// class _MiniCircleAction extends StatelessWidget {
//   const _MiniCircleAction({
//     required this.icon,
//     required this.color,
//     required this.bg,
//     required this.onTap,
//   });

//   final IconData icon;
//   final Color color;
//   final Color bg;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(999),
//       onTap: onTap,
//       child: Container(
//         width: 34,
//         height: 34,
//         decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
//         child: Icon(icon, size: 17, color: color),
//       ),
//     );
//   }
// }

// class _SwitchRow extends StatelessWidget {
//   const _SwitchRow({
//     required this.iconBg,
//     required this.iconColor,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.onChanged,
//   });

//   final Color iconBg;
//   final Color iconColor;
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
//           child: Icon(icon, size: 18, color: iconColor),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: AppColors.textDark,
//                   fontSize: 11.5,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   color: AppColors.textMuted.withOpacity(0.9),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Transform.scale(
//           scale: 0.92,
//           child: Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: AppColors.primaryBlue,
//             activeTrackColor: AppColors.primaryBlue.withOpacity(0.25),
//             inactiveThumbColor: const Color(0xFFD1D5DB),
//             inactiveTrackColor: const Color(0xFFE5E7EB),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _AccountTile extends StatelessWidget {
//   const _AccountTile({
//     required this.icon,
//     required this.title,
//     this.trailingBadgeText,
//     this.trailingBadgeColor,
//     this.trailingBadgeBg,
//   });

//   final IconData icon;
//   final String title;
//   final String? trailingBadgeText;
//   final Color? trailingBadgeColor;
//   final Color? trailingBadgeBg;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: const BoxDecoration(
//               color: Color(0xFFF2F4FA),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 18, color: AppColors.textMuted),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: AppColors.textDark,
//                 fontSize: 11.8,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//           if (trailingBadgeText != null)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                 color: trailingBadgeBg ?? const Color(0xFFEAF9F1),
//                 borderRadius: BorderRadius.circular(999),
//                 border: Border.all(
//                   color: (trailingBadgeBg ?? const Color(0xFFEAF9F1)).withOpacity(0.0),
//                 ),
//               ),
//               child: Text(
//                 trailingBadgeText!,
//                 style: TextStyle(
//                   color: trailingBadgeColor ?? AppColors.success,
//                   fontSize: 9,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: 0.7,
//                 ),
//               ),
//             ),
//           const SizedBox(width: 8),
//           Icon(Icons.chevron_right_rounded,
//               size: 22, color: AppColors.textMuted.withOpacity(0.6)),
//         ],
//       ),
//     );
//   }
// }

// class _TileDivider extends StatelessWidget {
//   const _TileDivider();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 56, right: 12),
//       child: Divider(height: 1, thickness: 1, color: const Color(0xFFE9ECF6)),
//     );
//   }
// }






import 'package:flutter/material.dart';
import '../main.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _aiSentinel = true;
  bool _shadowTracking = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                Row(
                  children: [
                    _TopCircleButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    _TopCircleButton(
                      icon: Icons.more_horiz_rounded,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Avatar
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD8B38A),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.person_rounded,
                              size: 48, color: Color(0xFF2A2A2A)),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bg, width: 3),
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                const Center(
                  child: Text(
                    'Maya Sharma',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF2FF),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFE3E7FF)),
                    ),
                    child: Text(
                      'AI-Safe Member since 2023',
                      style: TextStyle(
                        color: AppColors.primaryBlue.withOpacity(0.95),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: SizedBox(
                    height: 34,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Center(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Emergency Contacts
                Row(
                  children: [
                    const Text(
                      'Emergency Contacts',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Add New',
                      style: TextStyle(
                        color: AppColors.primaryBlue.withOpacity(0.95),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE9ECF6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2B7A5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.person_rounded,
                              size: 22, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Aisha Sharma',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mother • Primary Contact',
                              style: TextStyle(
                                color: AppColors.textMuted.withOpacity(0.9),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _MiniCircleAction(
                        icon: Icons.call_rounded,
                        color: AppColors.primaryBlue,
                        bg: const Color(0xFFEFF2FF),
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _MiniCircleAction(
                        icon: Icons.edit_rounded,
                        color: AppColors.textMuted.withOpacity(0.9),
                        bg: const Color(0xFFF2F4FA),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // AI Safety Features
                const Text(
                  'AI Safety Features',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE9ECF6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SwitchRow(
                        iconBg: const Color(0xFFEFF2FF),
                        iconColor: AppColors.primaryBlue,
                        icon: Icons.shield_rounded,
                        title: 'AI Sentinel Monitoring',
                        subtitle: 'Auto-detect distress signals',
                        value: _aiSentinel,
                        onChanged: (v) => setState(() => _aiSentinel = v),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFE9ECF6)),
                      const SizedBox(height: 10),
                      _SwitchRow(
                        iconBg: const Color(0xFFFFE6F1),
                        iconColor: AppColors.pink,
                        icon: Icons.location_on_rounded,
                        title: 'Shadow Tracking',
                        subtitle: 'Discrete location broadcast',
                        value: _shadowTracking,
                        onChanged: (v) => setState(() => _shadowTracking = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Account & Privacy
                const Text(
                  'Account & Privacy',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE9ECF6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      _AccountTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Privacy Settings',
                      ),
                      _TileDivider(),
                      _AccountTile(
                        icon: Icons.verified_user_outlined,
                        title: 'Identity Verification',
                        trailingBadgeText: 'ACTIVE',
                        trailingBadgeColor: Color(0xFF23C16B),
                        trailingBadgeBg: Color(0xFFEAF9F1),
                      ),
                      _TileDivider(),
                      _AccountTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Logout
                SizedBox(
                  height: 46,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE9ECF6)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.logout_rounded,
                              size: 18, color: Color(0xFFFF3B30)),
                          SizedBox(width: 10),
                          Text(
                            'Logout Account',
                            style: TextStyle(
                              color: Color(0xFFFF3B30),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Center(
                  child: Text(
                    'SHRI App Version 4.2.0 • Secured by SHRI AI',
                    style: TextStyle(
                      color: AppColors.textMuted.withOpacity(0.75),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: bottomInset + 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopCircleButton extends StatelessWidget {
  const _TopCircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE9ECF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.textDark.withOpacity(0.9)),
      ),
    );
  }
}

class _MiniCircleAction extends StatelessWidget {
  const _MiniCircleAction({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.92,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withOpacity(0.25),
            inactiveThumbColor: const Color(0xFFD1D5DB),
            inactiveTrackColor: const Color(0xFFE5E7EB),
          ),
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.icon,
    required this.title,
    this.trailingBadgeText,
    this.trailingBadgeColor,
    this.trailingBadgeBg,
  });

  final IconData icon;
  final String title;
  final String? trailingBadgeText;
  final Color? trailingBadgeColor;
  final Color? trailingBadgeBg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4FA),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.textMuted),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 11.8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (trailingBadgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: trailingBadgeBg ?? const Color(0xFFEAF9F1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                trailingBadgeText!,
                style: TextStyle(
                  color: trailingBadgeColor ?? AppColors.success,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded,
              size: 22, color: AppColors.textMuted.withOpacity(0.6)),
        ],
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 56, right: 12),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFE9ECF6)),
    );
  }
}