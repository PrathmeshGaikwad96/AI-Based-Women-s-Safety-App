import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../state/app_state.dart';
import '../state/auth_state.dart';
import 'edit_profile.dart';
import 'auth/login.dart';
import 'admin/admin_panel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _shadowTracking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthState>(context, listen: false).refreshAdminStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    final user = authState.currentUser;

    if (user != null && appState.currentUserId != user.uid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AppState>(context, listen: false).loadUserData(user.uid);
      });
    }

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

                Center(
                  child: Text(
                    user?.name ?? 'Guest User',
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                if (user?.email != null || user?.phone != null) ...[
                  Center(
                    child: Text(
                      '${user?.email ?? ""}  •  ${user?.phone ?? ""}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],

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

                if (user?.uid != null) ...[
                  const SizedBox(height: 6),
                  Center(
                    child: SelectableText(
                      'UID: ${user!.uid}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

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
                    InkWell(
                      onTap: () => _showAddGuardianDialog(context, appState),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(
                          'Add New',
                          style: TextStyle(
                            color: AppColors.primaryBlue.withOpacity(0.95),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                appState.guardians.isEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE9ECF6)),
                        ),
                        child: Center(
                          child: Text(
                            'No emergency contacts added yet.',
                            style: TextStyle(
                              color: AppColors.textMuted.withOpacity(0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: appState.guardians.map((guardian) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
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
                                      Text(
                                        guardian.name,
                                        style: const TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${guardian.relation} • ${guardian.phone}',
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
                                  onTap: () => _makeCall(guardian.phone),
                                ),
                                const SizedBox(width: 8),
                                _MiniCircleAction(
                                  icon: Icons.delete_outline_rounded,
                                  color: Colors.red,
                                  bg: const Color(0xFFFFECEB),
                                  onTap: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text('Delete Contact', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        content: Text('Are you sure you want to remove ${guardian.name} from your safety circle?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Remove', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await appState.removeCircleGuardian(guardian.id);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Emergency contact removed.')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
                        value: appState.isVoiceSosEnabled,
                        onChanged: (v) => appState.toggleVoiceSOS(user, v),
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
                    children: [
                      const _AccountTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Privacy Settings',
                      ),
                      const _TileDivider(),
                      const _AccountTile(
                        icon: Icons.verified_user_outlined,
                        title: 'Identity Verification',
                        trailingBadgeText: 'ACTIVE',
                        trailingBadgeColor: Color(0xFF23C16B),
                        trailingBadgeBg: Color(0xFFEAF9F1),
                      ),
                      const _TileDivider(),
                      InkWell(
                        onTap: () => _showHelpSupportDialog(context),
                        child: const _AccountTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                        ),
                      ),
                      if (authState.isAdmin || !authState.isFirebaseEnabled) ...[
                        const _TileDivider(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                            );
                          },
                          child: const _AccountTile(
                            icon: Icons.admin_panel_settings_outlined,
                            title: 'Admin Control Console',
                            trailingBadgeText: 'SYSTEM',
                            trailingBadgeColor: AppColors.primaryBlue,
                            trailingBadgeBg: Color(0xFFEFF2FF),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Logout
                SizedBox(
                  height: 46,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          title: const Text(
                            'Logout Account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          content: const Text('Are you sure you want to log out of your account?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Logout', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await authState.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      }
                    },
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

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF2FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.help_outline_rounded, color: AppColors.primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Help & Support',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Need immediate assistance or have queries regarding SHRI safety features?',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE9ECF6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SHRI SUPPORT HELPLINE',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.phone_rounded, color: AppColors.success, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          '+91 8010144843',
                          style: TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _makeCall('8010144843');
                          },
                          child: const Text('CALL NOW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildFaqItem('How does AI Sentinel monitoring work?', 'It runs in the background and auto-detects predefined audio keywords to trigger an emergency SOS alert immediately.'),
              _buildFaqItem('Can I use the app without active internet?', 'Yes, the app has a local fallback mode for fake call operations and basic offline instructions.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(color: AppColors.textDark, fontSize: 10.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(answer, style: const TextStyle(color: AppColors.textMuted, fontSize: 10, height: 1.3, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showAddGuardianDialog(BuildContext context, AppState appState) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Add Safety Circle Contact',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'NAME',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 8),
                _DialogInputField(
                  controller: nameController,
                  hintText: 'e.g. John Doe',
                ),
                const SizedBox(height: 14),
                const Text(
                  'PHONE NUMBER',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 8),
                _DialogInputField(
                  controller: phoneController,
                  hintText: 'e.g. +919876543210',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),
                const Text(
                  'RELATIONSHIP',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 8),
                _DialogInputField(
                  controller: relationController,
                  hintText: 'e.g. Father, Friend',
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();
                final relation = relationController.text.trim();

                if (name.isEmpty || phone.isEmpty || relation.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                if (phone.length < 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid phone number')),
                  );
                  return;
                }

                await appState.addNewGuardian(name, phone, relation);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added to safety circle')),
                  );
                }
              },
              child: const Text(
                'Add Contact',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makeCall(String phone) async {
    final url = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch dialer';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place call: $e')),
        );
      }
    }
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

class _DialogInputField extends StatelessWidget {
  const _DialogInputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: AppColors.primaryBlue,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textMuted.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}