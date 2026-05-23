import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:basic/main.dart';
import '../state/app_state.dart';
import '../models/scheme_model.dart';
import 'ai_screen.dart';

class GovernmentSchemeScreen extends StatefulWidget {
  const GovernmentSchemeScreen({super.key});

  @override
  State<GovernmentSchemeScreen> createState() => _GovernmentSchemeScreenState();
}

class _GovernmentSchemeScreenState extends State<GovernmentSchemeScreen> {
  int _selectedChipIndex = 0;
  final List<String> _chips = const [
    'All Schemes',
    'Safety & Protection',
    'Financial Assistance',
    'Education Support',
    'Welfare & Housing',
  ];

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open page: $e')),
        );
      }
    }
  }

  void _askShriAI(String schemeTitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AiScreen(
          initialMessage: 'Tell me more about the "$schemeTitle" scheme, including its eligibility and application process.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // Filter schemes based on selected category chip
    final filteredSchemes = appState.schemes.where((scheme) {
      if (_selectedChipIndex == 0) return true; // All
      final selectedCategory = _chips[_selectedChipIndex];
      return scheme.category.toLowerCase() == selectedCategory.toLowerCase();
    }).toList();

    // Select featured scheme: Majhi Ladki Bahin Yojana or Sakhi OSC, or first in list
    SchemeModel? featuredScheme;
    if (appState.schemes.isNotEmpty) {
      featuredScheme = appState.schemes.firstWhere(
        (s) => s.title.contains('Ladki Bahin') || s.title.contains('Sakhi'),
        orElse: () => appState.schemes.first,
      );
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  // Sticky Top Bar
                  Container(
                    color: AppColors.bg,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => Navigator.of(context).pop(),
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(Icons.chevron_left_rounded,
                                size: 26, color: AppColors.purple),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Government Schemes',
                              style: TextStyle(
                                color: AppColors.purple,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40), // Balance the back button spacing
                      ],
                    ),
                  ),

                  // Sticky Chips List
                  Container(
                    height: 38,
                    color: AppColors.bg,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _chips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final selected = _selectedChipIndex == i;
                        return _SchemeChip(
                          text: _chips[i],
                          selected: selected,
                          onTap: () => setState(() => _selectedChipIndex = i),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Schemes List
                  Expanded(
                    child: filteredSchemes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.category_outlined, size: 48, color: AppColors.textMuted),
                                SizedBox(height: 12),
                                Text(
                                  'No schemes available in this category.',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.fromLTRB(16, 4, 16, bottomInset + 88),
                            itemCount: filteredSchemes.length + (_selectedChipIndex == 0 && featuredScheme != null ? 1 : 0),
                            separatorBuilder: (_, __) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              // If on "All Schemes" tab, inject the featured card at the top
                              if (_selectedChipIndex == 0 && featuredScheme != null) {
                                if (index == 0) {
                                  return _FeaturedSchemeCard(
                                    scheme: featuredScheme,
                                    onApply: () => _launchUrl(featuredScheme!.officialUrl),
                                    onAskAI: () => _askShriAI(featuredScheme!.title),
                                  );
                                }
                                // Adjust index for actual list
                                final actualScheme = filteredSchemes[index - 1];
                                return _buildSchemeCard(actualScheme);
                              } else {
                                final actualScheme = filteredSchemes[index];
                                return _buildSchemeCard(actualScheme);
                              }
                            },
                          ),
                  ),
                ],
              ),

              // Floating purple button bottom-right (Tapping opens SHRI AI page)
              Positioned(
                right: 18,
                bottom: 18 + bottomInset,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AiScreen(),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(999),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.purple,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purple.withOpacity(0.28),
                              blurRadius: 24,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.auto_awesome_rounded,
                            color: Colors.white, size: 22),
                      ),
                      Positioned(
                        right: 6,
                        top: 8,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D77),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(SchemeModel scheme) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    // Dynamically assign icons/colors based on category
    switch (scheme.category.toLowerCase()) {
      case 'safety & protection':
        icon = Icons.shield_rounded;
        iconColor = AppColors.purple;
        iconBg = const Color(0xFFF2E9FF);
        break;
      case 'financial assistance':
        icon = Icons.account_balance_wallet_rounded;
        iconColor = Colors.green;
        iconBg = const Color(0xFFE8F5E9);
        break;
      case 'education support':
        icon = Icons.school_rounded;
        iconColor = Colors.blue;
        iconBg = const Color(0xFFE3F2FD);
        break;
      case 'maternal care':
        icon = Icons.child_care_rounded;
        iconColor = Colors.red;
        iconBg = const Color(0xFFFFEBEE);
        break;
      case 'welfare & housing':
      default:
        icon = Icons.home_work_rounded;
        iconColor = Colors.orange;
        iconBg = const Color(0xFFFFF3E0);
        break;
    }

    return _SchemeSmallCard(
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      title: scheme.title,
      description: scheme.description,
      eligibility: scheme.eligibility,
      onApply: () => _launchUrl(scheme.officialUrl),
      onAskAI: () => _askShriAI(scheme.title),
    );
  }
}

class _SchemeChip extends StatelessWidget {
  const _SchemeChip({
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.purple : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.purple : const Color(0xFFE9ECF6),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  )
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _FeaturedSchemeCard extends StatelessWidget {
  const _FeaturedSchemeCard({
    required this.scheme,
    required this.onApply,
    required this.onAskAI,
  });

  final SchemeModel scheme;
  final VoidCallback onApply;
  final VoidCallback onAskAI;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/womens.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFBFA07C), Color(0xFFF1D8BE)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 18),
                              child: Container(
                                width: 96,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 36),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Positioned(
                    left: 14,
                    bottom: 44,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 16,
                    right: 14,
                    child: Text(
                      scheme.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheme.description,
                    style: TextStyle(
                      color: AppColors.textMuted.withOpacity(0.95),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.groups_2_outlined,
                          size: 14, color: AppColors.purple.withOpacity(0.95)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Eligibility: ${scheme.eligibility}',
                          style: TextStyle(
                            color: AppColors.textMuted.withOpacity(0.95),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 34,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: onApply,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.purple.withOpacity(0.20),
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Apply Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE9ECF6)),
                  const SizedBox(height: 10),

                  InkWell(
                    onTap: onAskAI,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome_rounded,
                              size: 15, color: AppColors.purple.withOpacity(0.95)),
                          const SizedBox(width: 8),
                          Text(
                            'Ask SHRI AI about this scheme',
                            style: TextStyle(
                              color: AppColors.purple.withOpacity(0.95),
                              fontSize: 10.8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SchemeSmallCard extends StatelessWidget {
  const _SchemeSmallCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.eligibility,
    required this.onApply,
    required this.onAskAI,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;
  final String eligibility;
  final VoidCallback onApply;
  final VoidCallback onAskAI;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF9F1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: TextStyle(
                color: AppColors.textMuted.withOpacity(0.95),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  'ELIGIBILITY: ${eligibility.toUpperCase()}',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.9),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 34,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: onApply,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withOpacity(0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Apply Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE9ECF6)),
          const SizedBox(height: 6),
          
          InkWell(
            onTap: onAskAI,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      size: 14, color: AppColors.purple.withOpacity(0.85)),
                  const SizedBox(width: 6),
                  Text(
                    'Ask SHRI AI about this scheme',
                    style: TextStyle(
                      color: AppColors.purple.withOpacity(0.85),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}