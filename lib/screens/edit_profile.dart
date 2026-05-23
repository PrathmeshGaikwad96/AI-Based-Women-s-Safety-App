import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../state/app_state.dart';
import '../state/auth_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color _purple = Color(0xFF6D28D9);
  static const Color _border = Color(0xFFE7EAF3);
  static const Color _muted = Color(0xFF7E8497);

  bool _initialized = false;
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _dob;

  bool _immediateAlerts = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final authState = Provider.of<AuthState>(context);
      final user = authState.currentUser;
      _fullName = TextEditingController(text: user?.name ?? '');
      _email = TextEditingController(text: user?.email ?? '');
      _phone = TextEditingController(text: user?.phone ?? '');
      _dob = TextEditingController(text: '08/24/1995');
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _dob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    final user = authState.currentUser;

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
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => Navigator.of(context).pop(),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 26,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40, height: 40),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 6),

                      // Avatar + Change photo
                      Center(
                        child: Column(
                          children: [
                            Stack(
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
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: _purple,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.bg, width: 3),
                                    ),
                                    child: const Icon(
                                      Icons.photo_camera_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Change Photo',
                              style: TextStyle(
                                color: _purple,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      const _FieldLabel(text: 'FULL NAME'),
                      const SizedBox(height: 8),
                      _InputField(controller: _fullName),

                      const SizedBox(height: 14),
                      const _FieldLabel(text: 'EMAIL ADDRESS'),
                      const SizedBox(height: 8),
                      _InputField(controller: _email, readOnly: true),

                      const SizedBox(height: 14),
                      const _FieldLabel(text: 'PHONE NUMBER'),
                      const SizedBox(height: 8),
                      _InputField(controller: _phone),

                      const SizedBox(height: 14),
                      const _FieldLabel(text: 'DATE OF BIRTH'),
                      const SizedBox(height: 8),
                      _InputField(
                        controller: _dob,
                        trailing: const Icon(Icons.calendar_month_rounded,
                            size: 18, color: _muted),
                        readOnly: true,
                        onTap: () {},
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Safety Preferences',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: _border),
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
                            _PreferenceRow(
                              iconBg: const Color(0xFFF2E9FF),
                              iconColor: _purple,
                              icon: Icons.notifications_active_rounded,
                              title: 'Immediate Alerts',
                              subtitle: 'Notify contacts on activation',
                              value: _immediateAlerts,
                              onChanged: (v) =>
                                  setState(() => _immediateAlerts = v),
                              activeColor: _purple,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF0F2F7),
                            ),
                            _PreferenceRow(
                              iconBg: const Color(0xFFFFE6F1),
                              iconColor: AppColors.pink,
                              icon: Icons.mic_rounded,
                              title: 'Voice Trigger',
                              subtitle: 'AI listening for keywords',
                              value: appState.isVoiceSosEnabled,
                              onChanged: (v) => appState.toggleVoiceSOS(user, v),
                              activeColor: _purple,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: bottomInset + 110),
                    ],
                  ),
                ),
              ),

              // Bottom button
              Container(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  border: Border(
                    top: BorderSide(color: Color(0xFFF0F2F7)),
                  ),
                ),
                child: SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withOpacity(0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        final name = _fullName.text.trim();
                        final phone = _phone.text.trim();
                        if (name.isEmpty || phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Name and phone cannot be empty')),
                          );
                          return;
                        }

                        try {
                          await authState.updateProfile(
                            name: name,
                            phone: phone,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated successfully')),
                            );
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update profile: $e')),
                            );
                          }
                        }
                      },
                      child: const Center(
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                          ),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: _EditProfileScreenState._muted.withOpacity(0.9),
        fontSize: 9.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.9,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    this.trailing,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final Widget? trailing;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _EditProfileScreenState._border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              cursorColor: _EditProfileScreenState._purple,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
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
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _EditProfileScreenState._muted.withOpacity(0.9),
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
              activeColor: Colors.white,
              activeTrackColor: activeColor,
              inactiveThumbColor: const Color(0xFFD1D5DB),
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
          ),
        ],
      ),
    );
  }
}