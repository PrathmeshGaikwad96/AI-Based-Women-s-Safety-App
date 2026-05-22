import 'package:flutter/material.dart';
import '../main.dart';

class GovernmentSchemeScreen extends StatefulWidget {
  const GovernmentSchemeScreen({super.key});

  @override
  State<GovernmentSchemeScreen> createState() => _GovernmentSchemeScreenState();
}

class _GovernmentSchemeScreenState extends State<GovernmentSchemeScreen> {
  int _chip = 0;

  final _chips = const ['All Schemes', 'Safety', 'Legal Aid'];

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
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Row(
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
                        Expanded(
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
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () {},
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(Icons.search_rounded,
                                size: 22, color: AppColors.purple),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Chips
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _chips.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final selected = _chip == i;
                          return _SchemeChip(
                            text: _chips[i],
                            selected: selected,
                            onTap: () => setState(() => _chip = i),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Featured card
                    const _FeaturedSchemeCard(),

                    const SizedBox(height: 12),

                    // List cards
                    const _SchemeSmallCard(
                      icon: Icons.shield_rounded,
                      iconBg: Color(0xFFF2E9FF),
                      iconColor: AppColors.purple,
                      title: 'Mahila Police\nVolunteers',
                      status: 'ACTIVE',
                      description:
                          'Creating a link between police and\ncommunity for a safer environment f...',
                      footerLeft: 'AGE: 21+ YEARS',
                      footerRight: 'Apply Now',
                    ),
                    const SizedBox(height: 12),
                    const _SchemeSmallCard(
                      icon: Icons.home_work_rounded,
                      iconBg: Color(0xFFF2E9FF),
                      iconColor: AppColors.purple,
                      title: 'Working Women\nHostels',
                      status: 'ACTIVE',
                      description:
                          'Safe and affordable accommodation\nfor working women in urban and rur...',
                      footerLeft: 'STATE SPONSORED',
                      footerRight: 'Apply Now',
                    ),
                    const SizedBox(height: 12),
                    const _SchemeSmallCard(
                      icon: Icons.balance_rounded,
                      iconBg: Color(0xFFF2E9FF),
                      iconColor: AppColors.purple,
                      title: 'Nari Shakti Legal Clinic',
                      status: null,
                      description:
                          'Free legal assistance and awareness\nfor property and matrimonial rights.',
                      footerLeft: 'LEGAL AID',
                      footerRight: 'Apply Now',
                    ),

                    SizedBox(height: bottomInset + 90),
                  ],
                ),
              ),

              // Floating purple button bottom-right (with red dot)
              Positioned(
                right: 18,
                bottom: 18 + bottomInset,
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
            ],
          ),
        ),
      ),
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
  const _FeaturedSchemeCard();

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
            // Image
            SizedBox(
              height: 170,
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
                  const Positioned(
                    left: 14,
                    bottom: 16,
                    right: 14,
                    child: Text(
                      'One Stop Centre (Sakhi)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Integrated support for women affected by\n'
                    'violence, providing legal aid, medical support,\n'
                    'and counseling under one roof.',
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
                          'Eligibility: All Women',
                          style: TextStyle(
                            color: AppColors.textMuted.withOpacity(0.95),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 34,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () {},
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

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            size: 16, color: AppColors.purple.withOpacity(0.95)),
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
    required this.footerLeft,
    required this.footerRight,
    this.status,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;
  final String footerLeft;
  final String footerRight;
  final String? status;

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

              if (status != null) ...[
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

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(
                  footerLeft,
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.9),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              SizedBox(
                height: 34,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {},
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
                    child: Center(
                      child: Text(
                        footerRight,
                        style: const TextStyle(
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
          )
        ],
      ),
    );
  }
}