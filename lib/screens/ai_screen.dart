import 'package:flutter/material.dart';
import '../main.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({
    super.key,
    this.onBack,
  });

  /// Callback function for back button (top-left).
  /// If null, it will default to Navigator.pop(context).
  final VoidCallback? onBack;

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

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
          child: Column(
            children: [
              // Top Bar
              Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF0F2F7)),
                  ),
                ),
                child: Row(
                  children: [
                    // Back button (with callback)
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: _handleBack,
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 26,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_bubble_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SHRI AI',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF22C55E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ACTIVE MONITORING',
                                style: TextStyle(
                                  color: AppColors.textMuted.withOpacity(0.85),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4FA),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE9ECF6)),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: AppColors.textMuted.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),

              // Chat area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4FA),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFE9ECF6)),
                        ),
                        child: Text(
                          'TODAY',
                          style: TextStyle(
                            color: AppColors.textMuted.withOpacity(0.9),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const _AiMessage(
                        time: '12:04 PM',
                        text:
                            "I'm SHRI, your safety assistant. I'm\ncurrently monitoring your location.\nHow can I help you stay safe today?",
                      ),
                      const SizedBox(height: 14),

                      const _UserMessage(
                        time: '12:05 PM',
                        text: 'Show me nearby safe zones and\npolice stations.',
                      ),
                      const SizedBox(height: 14),

                      const _AiMessage(
                        time: '12:05 PM',
                        text:
                            "I've identified 3 safe zones within 500\nmeters. The nearest one is Central Park\nSecurity Booth (120m away).",
                        showMapPreview: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom section (quick actions + input)
              Container(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 12 + bottomInset),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFF0F2F7)),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: _BottomActionButton(
                            icon: Icons.near_me_rounded,
                            text: 'Nearby Help',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _BottomActionButton(
                            icon: Icons.gavel_rounded,
                            text: 'Safety Laws',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _BottomActionButton(
                            icon: Icons.share_rounded,
                            text: 'Share Live',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4FA),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE9ECF6)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    cursorColor: AppColors.primaryBlue,
                                    decoration: InputDecoration(
                                      hintText: 'Ask me anything...',
                                      hintStyle: TextStyle(
                                        color: AppColors.textMuted.withOpacity(0.75),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.mic_rounded,
                                    size: 18,
                                    color: AppColors.textMuted.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.20),
                                blurRadius: 20,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
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

class _AiMessage extends StatelessWidget {
  const _AiMessage({
    required this.text,
    required this.time,
    this.showMapPreview = false,
  });

  final String text;
  final String time;
  final bool showMapPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    )
                  ],
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: Text(
            time,
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.75),
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (showMapPreview) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.asset(
                  'assets/chat_map.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _ChatMapFallback(),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({required this.text, required this.time});

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4FA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE9ECF6)),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textDark.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: TextStyle(
            color: AppColors.textMuted.withOpacity(0.75),
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  const _BottomActionButton({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMapFallback extends StatelessWidget {
  const _ChatMapFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE7F0FF), Color(0xFFF7FBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(Icons.map_outlined,
            size: 40, color: AppColors.textMuted.withOpacity(0.4)),
      ),
    );
  }
}