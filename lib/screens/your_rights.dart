// import 'package:basic/main.dart';
// import 'package:flutter/material.dart';

// class YourRightsScreen extends StatelessWidget {
//   const YourRightsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//         textScaler: const TextScaler.linear(1.0),
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.bg,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top Bar
//                 Row(
//                   children: [
//                     InkWell(
//                       borderRadius: BorderRadius.circular(999),
//                       onTap: () => Navigator.of(context).pop(),
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: const Color(0xFFE9ECF6)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.04),
//                               blurRadius: 18,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.chevron_left_rounded,
//                           color: AppColors.textDark,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     const Expanded(
//                       child: Text(
//                         'Legal Rights Guide',
//                         style: TextStyle(
//                           color: AppColors.textDark,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       borderRadius: BorderRadius.circular(999),
//                       onTap: () {
//                         // Hook your emergency exit logic here
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         height: 32,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFFEEF1),
//                           borderRadius: BorderRadius.circular(999),
//                           border: Border.all(color: const Color(0xFFFFD2DC)),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Icon(Icons.logout_rounded,
//                                 size: 14, color: Color(0xFFFF4D77)),
//                             SizedBox(width: 6),
//                             Text(
//                               'QUICK EXIT',
//                               style: TextStyle(
//                                 color: Color(0xFFFF4D77),
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: 0.6,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 12),

//                 // Search
//                 Container(
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF2F4FA),
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: const Color(0xFFE9ECF6)),
//                   ),
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 12),
//                       Icon(Icons.search_rounded,
//                           size: 18, color: AppColors.textMuted.withOpacity(0.85)),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: TextField(
//                           cursorColor: AppColors.primaryBlue,
//                           decoration: InputDecoration(
//                             hintText: 'Search for rights, laws, or acts...',
//                             hintStyle: TextStyle(
//                               color: AppColors.textMuted.withOpacity(0.75),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             border: InputBorder.none,
//                             isDense: true,
//                           ),
//                           style: const TextStyle(
//                             color: AppColors.textDark,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 14),

//                 // Section header
//                 Row(
//                   children: [
//                     const Text(
//                       'Legal Categories',
//                       style: TextStyle(
//                         color: AppColors.textDark,
//                         fontSize: 13.5,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEFF2FF),
//                         borderRadius: BorderRadius.circular(999),
//                         border: Border.all(color: const Color(0xFFE3E7FF)),
//                       ),
//                       child: const Text(
//                         '12 ACTS FOUND',
//                         style: TextStyle(
//                           color: AppColors.primaryBlue,
//                           fontSize: 9.5,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 0.6,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 // Card 1
//                 const _RightsCardDomesticViolence(),

//                 const SizedBox(height: 12),

//                 // Card 2
//                 const _RightsCardPosh(),

//                 const SizedBox(height: 12),

//                 // Card 3
//                 const _RightsCardFir(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RightsCardDomesticViolence extends StatelessWidget {
//   const _RightsCardDomesticViolence();

//   @override
//   Widget build(BuildContext context) {
//     return _BaseCard(
//       child: Column(
//         children: [
//           // header strip
//           Container(
//             padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F4FF),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryBlue,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(Icons.gavel_rounded, color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Domestic Violence Act',
//                         style: TextStyle(
//                           color: AppColors.textDark,
//                           fontSize: 12.5,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Protection of Women, 2005',
//                         style: TextStyle(
//                           color: AppColors.primaryBlue.withOpacity(0.9),
//                           fontSize: 10.5,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.info_outline_rounded,
//                     size: 18, color: AppColors.textMuted.withOpacity(0.75)),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           // "View Summary of Rights"
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Row(
//               children: [
//                 Text(
//                   'View Summary of Rights',
//                   style: TextStyle(
//                     color: AppColors.textMuted.withOpacity(0.95),
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(Icons.keyboard_arrow_down_rounded,
//                     size: 20, color: AppColors.textMuted.withOpacity(0.7)),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),
//           const _CardDivider(),

//           // actions row
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 38,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(999),
//                       onTap: () {},
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFEFF2FF),
//                           borderRadius: BorderRadius.circular(999),
//                           border: Border.all(color: const Color(0xFFE3E7FF)),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.download_rounded,
//                                 size: 16, color: AppColors.primaryBlue),
//                             SizedBox(width: 8),
//                             Text(
//                               'DOWNLOAD PDF',
//                               style: TextStyle(
//                                 color: AppColors.primaryBlue,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: 0.6,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: SizedBox(
//                     height: 38,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(999),
//                       onTap: () {},
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF151A2B),
//                           borderRadius: BorderRadius.circular(999),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.headset_mic_rounded,
//                                 size: 16, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               'GET HELP',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: 0.7,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
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

// class _RightsCardPosh extends StatelessWidget {
//   const _RightsCardPosh();

//   @override
//   Widget build(BuildContext context) {
//     return _BaseCard(
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFEEF4),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFF4D93),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(Icons.shield_rounded,
//                       color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Harassment & POSH',
//                         style: TextStyle(
//                           color: AppColors.textDark,
//                           fontSize: 12.5,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Workplace Safety Laws',
//                         style: TextStyle(
//                           color: const Color(0xFFFF4D93).withOpacity(0.95),
//                           fontSize: 10.5,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.lock_outline_rounded,
//                     size: 18, color: AppColors.textMuted.withOpacity(0.75)),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Row(
//               children: [
//                 Text(
//                   'Key Provisions',
//                   style: TextStyle(
//                     color: AppColors.textMuted.withOpacity(0.95),
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(Icons.keyboard_arrow_down_rounded,
//                     size: 20, color: AppColors.textMuted.withOpacity(0.7)),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//             child: SizedBox(
//               height: 40,
//               width: double.infinity,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(999),
//                 onTap: () {},
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFE6F1),
//                     borderRadius: BorderRadius.circular(999),
//                     border: Border.all(color: const Color(0xFFFFD1E4)),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'LEARN COMPLAINT PROCESS',
//                       style: TextStyle(
//                         color: Color(0xFFFF2C74),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: 0.7,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _RightsCardFir extends StatelessWidget {
//   const _RightsCardFir();

//   @override
//   Widget build(BuildContext context) {
//     return _BaseCard(
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF2F3FF),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF4B52FF),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(Icons.badge_rounded,
//                       color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'FIR Guide & Police',
//                         style: TextStyle(
//                           color: AppColors.textDark,
//                           fontSize: 12.5,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Know Your Police Station\nRights',
//                         style: TextStyle(
//                           color: AppColors.primaryBlue.withOpacity(0.85),
//                           fontSize: 10.5,
//                           fontWeight: FontWeight.w700,
//                           height: 1.1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFEFF2FF),
//                     borderRadius: BorderRadius.circular(999),
//                     border: Border.all(color: const Color(0xFFE3E7FF)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.wifi_off_rounded,
//                           size: 13, color: AppColors.primaryBlue.withOpacity(0.9)),
//                       const SizedBox(width: 6),
//                       const Text(
//                         'OFFLINE',
//                         style: TextStyle(
//                           color: AppColors.primaryBlue,
//                           fontSize: 9.5,
//                           fontWeight: FontWeight.w900,
//                           letterSpacing: 0.7,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Row(
//               children: [
//                 Text(
//                   'How to file an FIR?',
//                   style: TextStyle(
//                     color: AppColors.textMuted.withOpacity(0.95),
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(Icons.keyboard_arrow_down_rounded,
//                     size: 20, color: AppColors.textMuted.withOpacity(0.7)),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//             child: SizedBox(
//               height: 40,
//               width: double.infinity,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(999),
//                 onTap: () {},
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(999),
//                     border: Border.all(color: const Color(0xFFE3E7FF)),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'STEP-BY-STEP GUIDE',
//                       style: TextStyle(
//                         color: AppColors.primaryBlue,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: 0.8,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BaseCard extends StatelessWidget {
//   const _BaseCard({required this.child});
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFFE9ECF6)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 22,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }

// class _CardDivider extends StatelessWidget {
//   const _CardDivider();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       child: Divider(
//         height: 1,
//         thickness: 1,
//         color: const Color(0xFFE9ECF6),
//       ),
//     );
//   }
// }
import 'package:basic/main.dart';
import 'package:flutter/material.dart';


class YourRightsScreen extends StatelessWidget {
  const YourRightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false, // IMPORTANT: removes the extra reserved bottom safe area
          child: SingleChildScrollView(
            // Reduced bottom padding so it doesn’t look like an unwanted blank area
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
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
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.textDark,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Legal Rights Guide',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        // Hook your quick-exit logic here
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEEF1),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFFFD2DC)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.logout_rounded,
                                size: 14, color: Color(0xFFFF4D77)),
                            SizedBox(width: 6),
                            Text(
                              'QUICK EXIT',
                              style: TextStyle(
                                color: Color(0xFFFF4D77),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Search
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9ECF6)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search_rounded,
                          size: 18,
                          color: AppColors.textMuted.withOpacity(0.85)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          cursorColor: AppColors.primaryBlue,
                          decoration: InputDecoration(
                            hintText: 'Search for rights, laws, or acts...',
                            hintStyle: TextStyle(
                              color: AppColors.textMuted.withOpacity(0.75),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Section header
                Row(
                  children: [
                    const Text(
                      'Legal Categories',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF2FF),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFE3E7FF)),
                      ),
                      child: const Text(
                        '12 ACTS FOUND',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Card 1
                const _RightsCardDomesticViolence(),
                const SizedBox(height: 12),

                // Card 2
                const _RightsCardPosh(),
                const SizedBox(height: 12),

                // Card 3
                const _RightsCardFir(),

                // Controlled bottom space (instead of big blank area)
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RightsCardDomesticViolence extends StatelessWidget {
  const _RightsCardDomesticViolence();

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          // header strip
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.gavel_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Domestic Violence Act',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Protection of Women, 2005',
                        style: TextStyle(
                          color: AppColors.primaryBlue.withOpacity(0.9),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.info_outline_rounded,
                    size: 18, color: AppColors.textMuted.withOpacity(0.75)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // "View Summary of Rights"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text(
                  'View Summary of Rights',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.95),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20, color: AppColors.textMuted.withOpacity(0.7)),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const _CardDivider(),

          // actions row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF2FF),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFE3E7FF)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.download_rounded,
                                size: 16, color: AppColors.primaryBlue),
                            SizedBox(width: 8),
                            Text(
                              'DOWNLOAD PDF',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF151A2B),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.headset_mic_rounded,
                                size: 16, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'GET HELP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _RightsCardPosh extends StatelessWidget {
  const _RightsCardPosh();

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEF4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D93),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shield_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harassment & POSH',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Workplace Safety Laws',
                        style: TextStyle(
                          color: const Color(0xFFFF4D93).withOpacity(0.95),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.lock_outline_rounded,
                    size: 18, color: AppColors.textMuted.withOpacity(0.75)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text(
                  'Key Provisions',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.95),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20, color: AppColors.textMuted.withOpacity(0.7)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6F1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFFFD1E4)),
                  ),
                  child: const Center(
                    child: Text(
                      'LEARN COMPLAINT PROCESS',
                      style: TextStyle(
                        color: Color(0xFFFF2C74),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.7,
                      ),
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

class _RightsCardFir extends StatelessWidget {
  const _RightsCardFir();

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B52FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.badge_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FIR Guide & Police',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Know Your Police Station\nRights',
                        style: TextStyle(
                          color: AppColors.primaryBlue.withOpacity(0.85),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF2FF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE3E7FF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          size: 13,
                          color: AppColors.primaryBlue.withOpacity(0.9)),
                      const SizedBox(width: 6),
                      const Text(
                        'OFFLINE',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text(
                  'How to file an FIR?',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.95),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20, color: AppColors.textMuted.withOpacity(0.7)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE3E7FF)),
                  ),
                  child: const Center(
                    child: Text(
                      'STEP-BY-STEP GUIDE',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
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

class _BaseCard extends StatelessWidget {
  const _BaseCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Divider(
        height: 1,
        thickness: 1,
        color: const Color(0xFFE9ECF6),
      ),
    );
  }
}