import 'package:flutter/material.dart';
import '../main.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  static const _purple = Color(0xFF6D28D9);
  static const _purpleSoft = Color(0xFFEFE7FF);
  static const _border = Color(0xFFE7EAF3);
  static const _muted = Color(0xFF7E8497);

  final _nameCtrl = TextEditingController(text: 'Dad');
  final _phoneCtrl = TextEditingController();

  int _identityChip = 0; // Dad/Mom/Boss/Pizza Shop
  int _schedule = 0; // Instantly / 1 min / 5 min / Custom
  bool _scriptedAudio = true;
  bool _vibrateMode = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // AppBar
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
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18, color: AppColors.textDark),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Fake Call Setup',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40, height: 40),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F7)),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(
                        text: 'CALLER IDENTITY',
                        color: _purple,
                      ),
                      const SizedBox(height: 14),

                      _FieldLabel(text: 'Caller Name'),
                      const SizedBox(height: 8),
                      _OutlinedInput(
                        controller: _nameCtrl,
                        hint: 'Dad',
                        purple: _purple,
                      ),

                      const SizedBox(height: 14),
                      _FieldLabel(text: 'Phone Number (Optional)'),
                      const SizedBox(height: 8),
                      _OutlinedInput(
                        controller: _phoneCtrl,
                        hint: '(555) 000-0000',
                        purple: _purple,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _PillChip(
                            text: 'Dad',
                            selected: _identityChip == 0,
                            purple: _purple,
                            purpleSoft: _purpleSoft,
                            onTap: () {
                              setState(() {
                                _identityChip = 0;
                                _nameCtrl.text = 'Dad';
                              });
                            },
                          ),
                          _PillChip(
                            text: 'Mom',
                            selected: _identityChip == 1,
                            purple: _purple,
                            purpleSoft: _purpleSoft,
                            onTap: () {
                              setState(() {
                                _identityChip = 1;
                                _nameCtrl.text = 'Mom';
                              });
                            },
                          ),
                          _PillChip(
                            text: 'Boss',
                            selected: _identityChip == 2,
                            purple: _purple,
                            purpleSoft: _purpleSoft,
                            onTap: () {
                              setState(() {
                                _identityChip = 2;
                                _nameCtrl.text = 'Boss';
                              });
                            },
                          ),
                          _PillChip(
                            text: 'Pizza Shop',
                            selected: _identityChip == 3,
                            purple: _purple,
                            purpleSoft: _purpleSoft,
                            onTap: () {
                              setState(() {
                                _identityChip = 3;
                                _nameCtrl.text = 'Pizza Shop';
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      _SectionTitle(
                        text: 'SCHEDULE CALL',
                        color: _purple,
                      ),
                      const SizedBox(height: 14),

                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.9,
                        ),
                        children: [
                          _ScheduleCard(
                            title: 'Instantly',
                            subtitle: 'Immediate trigger',
                            selected: _schedule == 0,
                            purple: _purple,
                            onTap: () => setState(() => _schedule = 0),
                          ),
                          _ScheduleCard(
                            title: '1 min',
                            subtitle: 'Delay',
                            selected: _schedule == 1,
                            purple: _purple,
                            onTap: () => setState(() => _schedule = 1),
                          ),
                          _ScheduleCard(
                            title: '5 min',
                            subtitle: 'Delay',
                            selected: _schedule == 2,
                            purple: _purple,
                            onTap: () => setState(() => _schedule = 2),
                          ),
                          _ScheduleCard(
                            title: 'Custom',
                            subtitle: 'Set time',
                            selected: _schedule == 3,
                            purple: _purple,
                            onTap: () => setState(() => _schedule = 3),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      _SectionTitle(
                        text: 'SETTINGS',
                        color: _purple,
                      ),
                      const SizedBox(height: 14),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _border),
                        ),
                        child: Column(
                          children: [
                            _SettingRow(
                              icon: Icons.volume_up_rounded,
                              label: 'Scripted Audio',
                              value: _scriptedAudio,
                              purple: _purple,
                              onChanged: (v) => setState(() => _scriptedAudio = v),
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F7)),
                            _SettingRow(
                              icon: Icons.vibration_rounded,
                              label: 'Vibrate Mode',
                              value: _vibrateMode,
                              purple: _purple,
                              onChanged: (v) => setState(() => _vibrateMode = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                      SizedBox(height: bottomInset + 90),
                    ],
                  ),
                ),
              ),

              // Bottom CTA area
              Container(
                padding: EdgeInsets.fromLTRB(18, 12, 18, 10 + bottomInset),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFF0F2F7)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 54,
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
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Start Simulation (demo)')),
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Start Simulation',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The call screen will appear after the selected delay. Use it\n'
                      'discreetly to exit uncomfortable situations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _muted.withOpacity(0.8),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 10.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
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
      style: const TextStyle(
        color: AppColors.textDark,
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _OutlinedInput extends StatelessWidget {
  const _OutlinedInput({
    required this.controller,
    required this.hint,
    required this.purple,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final Color purple;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: purple,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF9AA1B2).withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE7EAF3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: purple, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  const _PillChip({
    required this.text,
    required this.selected,
    required this.purple,
    required this.purpleSoft,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final Color purple;
  final Color purpleSoft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? purpleSoft : const Color(0xFFF2F4FA),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? purple : const Color(0xFFE7EAF3)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? purple : AppColors.textMuted.withOpacity(0.95),
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.purple,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final Color purple;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? purple : const Color(0xFFE7EAF3),
            width: selected ? 1.6 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: selected ? purple : AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textMuted.withOpacity(0.85),
                fontSize: 9.8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.purple,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final Color purple;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted.withOpacity(0.85)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.92,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: purple,
              inactiveThumbColor: const Color(0xFFD1D5DB),
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
          ),
        ],
      ),
    );
  }
}