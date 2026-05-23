import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:basic/main.dart';
import '../state/app_state.dart';

class YourRightsScreen extends StatefulWidget {
  const YourRightsScreen({super.key});

  @override
  State<YourRightsScreen> createState() => _YourRightsScreenState();
}

class _YourRightsScreenState extends State<YourRightsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _expandedRights = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpand(String id) {
    setState(() {
      if (_expandedRights.contains(id)) {
        _expandedRights.remove(id);
      } else {
        _expandedRights.add(id);
      }
    });
  }

  Future<void> _downloadPdf(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open PDF: $e')),
        );
      }
    }
  }

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanPhone);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not place call to $phone: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // Filter rights based on search query
    final filteredRights = appState.rights.where((right) {
      final query = _searchQuery.toLowerCase();
      return right.title.toLowerCase().contains(query) ||
          right.lawSection.toLowerCase().contains(query) ||
          right.description.toLowerCase().contains(query);
    }).toList();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top Bar (Sticky)
              Container(
                color: AppColors.bg,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
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
              ),

              // Search (Sticky)
              Container(
                color: AppColors.bg,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
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
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
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
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),

              // Header of categories (Sticky)
              Container(
                color: AppColors.bg,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    const Text(
                      'Legal Provisions',
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
                      child: Text(
                        '${filteredRights.length} ACTS FOUND',
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Dynamic List of Rights
              Expanded(
                child: filteredRights.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            Text(
                              'No matching rights or laws found.',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 16 + bottomInset),
                        itemCount: filteredRights.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final right = filteredRights[index];
                          final isExpanded = _expandedRights.contains(right.id);
                          
                          // Harmonized premium color palette rotation
                          Color headerBg;
                          Color accentColor;
                          IconData icon;
                          
                          if (index % 3 == 0) {
                            headerBg = const Color(0xFFF1F4FF);
                            accentColor = AppColors.primaryBlue;
                            icon = Icons.gavel_rounded;
                          } else if (index % 3 == 1) {
                            headerBg = const Color(0xFFFFEEF4);
                            accentColor = const Color(0xFFFF4D93);
                            icon = Icons.shield_rounded;
                          } else {
                            headerBg = const Color(0xFFF2F3FF);
                            accentColor = const Color(0xFF4B52FF);
                            icon = Icons.badge_rounded;
                          }

                          return _BaseCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Strip (Tapping toggles expansion)
                                InkWell(
                                  onTap: () => _toggleExpand(right.id),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                                    decoration: BoxDecoration(
                                      color: headerBg,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: accentColor,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Icon(icon, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                right.title,
                                                style: const TextStyle(
                                                  color: AppColors.textDark,
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                right.lawSection,
                                                style: TextStyle(
                                                  color: accentColor.withOpacity(0.9),
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          isExpanded
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons.keyboard_arrow_down_rounded,
                                          size: 20,
                                          color: AppColors.textMuted.withOpacity(0.75),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Summary Trigger / Brief Desc (if not expanded)
                                if (!isExpanded)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    child: InkWell(
                                      onTap: () => _toggleExpand(right.id),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              right.description,
                                              style: TextStyle(
                                                color: AppColors.textMuted.withOpacity(0.85),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                height: 1.35,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'View Details',
                                            style: TextStyle(
                                              color: accentColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Expanded Content
                                if (isExpanded) ...[
                                  const _CardDivider(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'DESCRIPTION',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          right.description,
                                          style: TextStyle(
                                            color: AppColors.textMuted.withOpacity(0.95),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'KEY PENALTIES / CONSEQUENCES',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          right.penalty,
                                          style: TextStyle(
                                            color: AppColors.textMuted.withOpacity(0.95),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'FILING / REDRESSAL PROCESS',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          right.filingProcess,
                                          style: TextStyle(
                                            color: AppColors.textMuted.withOpacity(0.95),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const _CardDivider(),
                                  
                                  // Actions Row
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
                                    child: Row(
                                      children: [
                                        // Download PDF Link
                                        Expanded(
                                          child: SizedBox(
                                            height: 38,
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(999),
                                              onTap: right.downloadPdfUrl.isNotEmpty
                                                  ? () => _downloadPdf(right.downloadPdfUrl)
                                                  : null,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: right.downloadPdfUrl.isNotEmpty
                                                      ? const Color(0xFFEFF2FF)
                                                      : Colors.grey.shade100,
                                                  borderRadius: BorderRadius.circular(999),
                                                  border: Border.all(
                                                    color: right.downloadPdfUrl.isNotEmpty
                                                        ? const Color(0xFFE3E7FF)
                                                        : Colors.grey.shade200,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.download_rounded,
                                                      size: 16,
                                                      color: right.downloadPdfUrl.isNotEmpty
                                                          ? AppColors.primaryBlue
                                                          : Colors.grey,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'DOWNLOAD PDF',
                                                      style: TextStyle(
                                                        color: right.downloadPdfUrl.isNotEmpty
                                                            ? AppColors.primaryBlue
                                                            : Colors.grey,
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
                                        
                                        // Help Hotline (Dials 181 for help)
                                        Expanded(
                                          child: SizedBox(
                                            height: 38,
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(999),
                                              onTap: () => _makeCall('181'),
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
                                                      'GET HELP (181)',
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
                                const SizedBox(height: 4),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFE9ECF6),
      ),
    );
  }
}