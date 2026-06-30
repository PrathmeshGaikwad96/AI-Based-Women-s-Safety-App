import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:basic/main.dart';
import '../state/app_state.dart';
import '../services/chat_service.dart';
import 'your_rights.dart';
import 'government_scheme.dart';
import 'safety_store.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({
    super.key,
    this.onBack,
    this.initialMessage,
  });

  final VoidCallback? onBack;
  final String? initialMessage;

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _isAiThinking = false;

  @override
  void initState() {
    super.initState();
    // Auto-send initial message if provided
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendText(widget.initialMessage!.trim());
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendText(String text) async {
    if (text.trim().isEmpty) return;

    final appState = Provider.of<AppState>(context, listen: false);
    
    setState(() {
      _isAiThinking = true;
    });
    
    _scrollToBottom();
    
    try {
      await appState.sendChatMessage(text);
    } catch (e) {
      debugPrint("Error sending chat: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isAiThinking = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

  // Opens settings sheet to configure custom Gemini API Key
  void _openSettingsSheet() async {
    final currentKey = await _chatService.getSavedApiKey() ?? '';
    final controller = TextEditingController(text: currentKey);
    bool obscureText = true;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF2FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.vpn_key_rounded, color: AppColors.primaryBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'SHRI AI Settings',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Configure a custom Google Gemini API Key. If left empty, SHRI AI uses a pre-configured default API key.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4FA),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE9ECF6)),
                    ),
                    child: TextField(
                      controller: controller,
                      obscureText: obscureText,
                      style: const TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Paste Gemini API Key here...',
                        hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.6), fontSize: 12),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: AppColors.textMuted,
                            size: 18,
                          ),
                          onPressed: () {
                            setModalState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse('https://aistudio.google.com/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.open_in_new_rounded, size: 13, color: AppColors.primaryBlue),
                        SizedBox(width: 6),
                        Text(
                          'Get a free Gemini API Key from Google AI Studio',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await _chatService.saveApiKey('');
                            if (context.mounted) Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('API Key cleared. Switched to Offline mode.')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE9ECF6)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Clear Key', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final key = controller.text.trim();
                            await _chatService.saveApiKey(key);
                            if (context.mounted) Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(key.isNotEmpty
                                    ? 'Gemini API Key saved successfully!'
                                    : 'API Key cleared. Offline mode active.'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Save Key', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleSuggestionPillClick(String text) {
    if (text.startsWith("Go to Your Rights") || text.startsWith("Go to Laws")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const YourRightsScreen()));
    } else if (text.startsWith("Go to Schemes")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GovernmentSchemeScreen()));
    } else if (text.startsWith("Go to Safety Store")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SafetyStoreScreen()));
    } else {
      _controller.clear();
      _sendText(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
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
                        Icons.bolt_rounded,
                        color: Colors.white,
                        size: 18,
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
                    // Settings Icon (to configure Gemini API key)
                    InkWell(
                      onTap: _openSettingsSheet,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4FA),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE9ECF6)),
                        ),
                        child: const Icon(
                          Icons.settings_rounded,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Chat area
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  itemCount: appState.chatHistory.length + (_isAiThinking ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    // Render typing bubble if at the end and thinking
                    if (index == appState.chatHistory.length && _isAiThinking) {
                      return const _AiTypingIndicator();
                    }

                    final msg = appState.chatHistory[index];
                    final formattedTime = "${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}";

                    if (msg.sender == 'user') {
                      return _UserMessage(
                        text: msg.text,
                        time: formattedTime,
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AiMessage(
                            text: msg.text,
                            time: formattedTime,
                          ),
                          // Display suggestion pills if available
                          if (msg.suggestionPills.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 44),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: msg.suggestionPills.map((pill) {
                                  return InkWell(
                                    onTap: () => _handleSuggestionPillClick(pill),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFFE9ECF6)),
                                      ),
                                      child: Text(
                                        pill,
                                        style: const TextStyle(
                                          color: AppColors.primaryBlue,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
                      );
                    }
                  },
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
                    // Dynamic Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _sendText("What safety services are near my location?"),
                            child: const _BottomActionButton(
                              icon: Icons.near_me_rounded,
                              text: 'Nearby Help',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => _sendText("Tell me about my legal rights and safety laws."),
                            child: const _BottomActionButton(
                              icon: Icons.gavel_rounded,
                              text: 'Safety Laws',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => _sendText("How do I share my live GPS coordinates with guardians?"),
                            child: const _BottomActionButton(
                              icon: Icons.share_rounded,
                              text: 'Share Live',
                            ),
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
                                    onSubmitted: (val) {
                                      if (val.trim().isNotEmpty) {
                                        _sendText(val.trim());
                                        _controller.clear();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Ask SHRI AI anything...',
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            final text = _controller.text.trim();
                            if (text.isNotEmpty) {
                              _sendText(text);
                              _controller.clear();
                            }
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
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
  });

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE9ECF6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.textDark,
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
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2FF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE3E7FF)),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w800,
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
      ),
    );
  }
}

class _AiTypingIndicator extends StatelessWidget {
  const _AiTypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE9ECF6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
              ),
            ],
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