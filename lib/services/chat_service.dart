import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class ChatService {
  static const String _apiKeyPrefsKey = 'gemini_api_key_custom';
  static const String _defaultApiKey = 'AQ.Ab8RN6Jp5X1kKcslTghSc6RVjmefNJ6HS0lpySDWqPQfOD5zzw';

  // Get saved API key from SharedPreferences
  Future<String?> getSavedApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPrefsKey);
  }

  // Save API key to SharedPreferences
  Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.trim().isEmpty) {
      await prefs.remove(_apiKeyPrefsKey);
    } else {
      await prefs.setString(_apiKeyPrefsKey, key.trim());
    }
  }

  // Generates suggestions based on message contents
  List<String> _getSuggestionsForText(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('sos') || lower.contains('emergency') || lower.contains('help') || lower.contains('danger')) {
      return ["Simulate SOS Alert", "Call Police", "Edit Circle"];
    } else if (lower.contains('right') || lower.contains('law') || lower.contains('ipc') || lower.contains('crpc') || lower.contains('posh')) {
      return ["Go to Your Rights", "Filing FIR guide", "Exemption from summoning"];
    } else if (lower.contains('scheme') || lower.contains('yojana') || lower.contains('ladki') || lower.contains('financial')) {
      return ["Go to Schemes", "Ladki Bahin Eligibility", "Sakhi One Stop Centre"];
    } else if (lower.contains('fake') || lower.contains('call') || lower.contains('escape')) {
      return ["Go to Fake Call", "Simulate Call Now", "Preset Contacts"];
    } else if (lower.contains('store') || lower.contains('product') || lower.contains('buy') || lower.contains('gear')) {
      return ["Go to Safety Store", "Pepper Spray", "Tactical Alarms"];
    } else if (lower.contains('circle') || lower.contains('guardian') || lower.contains('family')) {
      return ["Edit Guardians", "Add Emergency Contact", "Live Map Tracking"];
    }
    return ["Check Safety Score", "Unsafe Zones Near Me", "Ask about Laws"];
  }

  // Local fallback response generator
  ChatMessage _getLocalResponse(String userText, List<Map<String, dynamic>> schemes, List<Map<String, dynamic>> rights) {
    final text = userText.toLowerCase().trim();
    String reply = '';
    List<String> suggestions = [];

    // Find any matching scheme or right
    Map<String, dynamic>? matchedScheme;
    for (final s in schemes) {
      final title = (s['title'] ?? '').toString().toLowerCase();
      if (text.contains(title) || 
          (title.contains('ladki bahin') && (text.contains('ladki') || text.contains('bahin'))) ||
          (title.contains('one stop') && (text.contains('sakhi') || text.contains('one stop') || text.contains('osc')))) {
        matchedScheme = s;
        break;
      }
    }

    Map<String, dynamic>? matchedRight;
    for (final r in rights) {
      final title = (r['title'] ?? '').toString().toLowerCase();
      if (text.contains(title) ||
          (title.contains('posh') && text.contains('posh')) ||
          (title.contains('domestic violence') && text.contains('domestic')) ||
          (title.contains('zero fir') && text.contains('zero fir')) ||
          (title.contains('sunset arrest') && text.contains('sunset'))) {
        matchedRight = r;
        break;
      }
    }

    if (matchedScheme != null) {
      final title = matchedScheme['title'] ?? '';
      final desc = matchedScheme['description'] ?? '';
      final elig = matchedScheme['eligibility'] ?? '';
      final steps = List<dynamic>.from(matchedScheme['applicationSteps'] ?? []);
      final url = matchedScheme['officialUrl'] ?? '';

      reply = "Here are the details for the **$title** scheme:\n\n"
              "• **Description**: $desc\n"
              "• **Eligibility**: $elig\n"
              "• **Steps to Apply**:\n${steps.asMap().entries.map((e) => '  ${e.key + 1}. ${e.value}').join('\n')}\n"
              "• **Official URL**: $url";
      suggestions = ["Go to Schemes", "Ask about other schemes", "Main Menu"];
    } else if (matchedRight != null) {
      final title = matchedRight['title'] ?? '';
      final desc = matchedRight['description'] ?? '';
      final section = matchedRight['lawSection'] ?? '';
      final penalty = matchedRight['penalty'] ?? '';
      final process = matchedRight['filingProcess'] ?? '';

      reply = "Here is your legal guide on **$title**:\n\n"
              "• **Law/Section**: $section\n"
              "• **Details**: $desc\n"
              "• **Penalty/Consequences**: $penalty\n"
              "• **Redressal/How to File**: $process";
      suggestions = ["Go to Your Rights", "Filing FIR guide", "Main Menu"];
    } else if (text.contains('hi') || text.contains('hello') || text.contains('hey') || text.contains('greetings')) {
      reply = "Hello! I am **SHRI**, your personal AI safety assistant. I can guide you through legal rights, safety tools, and emergency actions. How can I help you stay safe today?";
      suggestions = ["Check Safety Score", "Show Unsafe Zones", "How to trigger SOS?"];
    } else if (text.contains('how are you')) {
      reply = "I am operating at full capacity and ready to assist you. I'm actively monitoring your safety score and nearby risk hotspots in the background. How can I assist you right now?";
      suggestions = ["Show Unsafe Zones", "Go to Fake Call", "Ask about Laws"];
    } else if (text.contains('who are you') || text.contains('your name') || text.contains('created you') || text.contains('about yourself')) {
      reply = "I am **SHRI** (Safety & Hazard Response Interface), built to act as your smart safety companion. I scan environmental data, manage your safety circle, and guide you through legal rights and government welfare policies in India.";
      suggestions = ["Check Safety Score", "Go to Your Rights", "Main Menu"];
    } else if (text.contains('sos') || text.contains('emergency') || text.contains('help') || text.contains('danger') || text.contains('save me') || text.contains('police')) {
      reply = "🚨 **Emergency Actions**:\n\n"
              "1. **Trigger SOS**: Tap the glowing red button on the home screen or yell **'HELP'** or **'DANGER'** multiple times.\n"
              "2. **Contact Police**: Dial **112** (emergency line in India).\n"
              "3. **Guardians Alerted**: Your live GPS coordinates and battery level are immediately broadcasted to your safety circle.";
      suggestions = ["Simulate SOS Alert", "Call Police", "Edit Circle"];
    } else if (text.contains('fake call') || text.contains('call') || text.contains('exit') || text.contains('escape')) {
      reply = "📞 **Fake Call Escape Strategy**:\n\n"
              "The Fake Call simulation is designed to help you exit uncomfortable or threatening situations discreetly.\n"
              "• Go to the **Fake Call** screen, set a delay (instantly, 1 min, 5 min), and click **Start Simulation**.\n"
              "• When it rings, decline to cut the sound, or answer to view a realistic ongoing call screen.";
      suggestions = ["Go to Fake Call", "Simulate Call Now", "Preset Contacts"];
    } else if (text.contains('live track') || text.contains('track') || text.contains('share location') || text.contains('map')) {
      reply = "📍 **Live Tracking & Navigation**:\n\n"
              "You can share your real-time path with your guardians continuously.\n"
              "• Go to **Live Track** on the home screen to view your path, see nearby police stations and hospitals on the map, and monitor safety updates.";
      suggestions = ["Go to Live Track", "Show Unsafe Zones", "Edit Circle"];
    } else if (text.contains('right') || text.contains('law') || text.contains('legal') || text.contains('ipc') || text.contains('crpc') || text.contains('rights') || text.contains('laws')) {
      reply = "⚖️ **Legal Safeguards in India**:\n\n"
              "You have strong legal protections, including:\n"
              "• **Zero FIR**: You can file an FIR at any police station regardless of where the incident occurred.\n"
              "• **Sunset Arrest Exception**: Women cannot be arrested after sunset and before sunrise except in extraordinary circumstances with a magistrate's order.\n"
              "• **POSH Act**: Protection against harassment in workplace settings.\n\n"
              "Ask about a specific law or select 'Go to Your Rights' for the full index.";
      suggestions = ["Go to Your Rights", "Sunset Arrest Exception", "Right to File a Zero FIR"];
    } else if (text.contains('scheme') || text.contains('yojana') || text.contains('schemes') || text.contains('yojanas') || text.contains('welfare')) {
      reply = "💼 **Government Welfare Schemes**:\n\n"
              "We track multiple welfare and aid programs:\n"
              "1. **Majhi Ladki Bahin Yojana**: Direct financial assistance for women in Maharashtra.\n"
              "2. **Sakhi One Stop Centre**: 24/7 medical aid, shelter, and legal support in every district.\n"
              "3. **Pradhan Mantri Matru Vandana Yojana**: Maternity nutrition incentive payouts.\n\n"
              "Ask me about any yojana or select 'Go to Schemes' to see all.";
      suggestions = ["Go to Schemes", "Majhi Ladki Bahin Yojana", "One Stop Centre (Sakhi)"];
    } else if (text.contains('store') || text.contains('pepper') || text.contains('spray') || text.contains('flashlight') || text.contains('gear') || text.contains('product')) {
      reply = "🛍️ **SHRI Safety Store**:\n\n"
              "Equip yourself with self-defense tools directly from the in-app store, including:\n"
              "• High-intensity Pepper Spray\n"
              "• Personal keychain alarm sirens\n"
              "• Portable GPS tracker devices\n\n"
              "Visit the safety store page to check catalog or add items to your wishlist.";
      suggestions = ["Go to Safety Store", "View pepper spray", "Wishlist"];
    } else if (text.contains('circle') || text.contains('guardian') || text.contains('parents') || text.contains('family')) {
      reply = "👥 **Safety Circle Management**:\n\n"
              "Your Safety Circle consists of trusted guardians who are instantly alerted when you trigger an SOS. They receive your real-time coordinates, address, and battery level.\n"
              "• You can add, edit, or remove guardians directly from your **Profile** screen.";
      suggestions = ["Edit Circle", "Add Emergency Contact", "Live Map Tracking"];
    } else if (text.contains('score') || text.contains('safety score') || text.contains('risk') || text.contains('unsafe') || text.contains('hotspot')) {
      reply = "📊 **Safety Score & Risk Zones**:\n\n"
              "Your **AI Safety Score** calculates safety based on street lighting, density, and local reports.\n"
              "• **90% - 100%**: Safe surroundings.\n"
              "• **70% - 89%**: Moderate risk. Stay alert.\n"
              "• **Below 70%**: High danger zone. Avoid isolated paths.\n\n"
              "If you enter a marked red risk zone, SHRI will sound a subtle alert and notify you immediately.";
      suggestions = ["Check Safety Score", "Show Unsafe Zones", "Go to Live Track"];
    } else {
      reply = "As your AI Safety Companion, I can guide you through India's legal rights, government schemes, and emergency tools. Try asking me:\n\n"
              "• *'What is a Zero FIR?'*\n"
              "• *'Tell me about Majhi Ladki Bahin Yojana'*\n"
              "• *'How do I add a guardian?'*\n"
              "• *'How does the fake call escape work?'*\n\n"
              "Or choose one of the options below.";
      suggestions = ["Go to Schemes", "Go to Your Rights", "How to trigger SOS?"];
    }

    return ChatMessage(
      id: 'ai_local_${DateTime.now().millisecondsSinceEpoch}',
      text: reply,
      sender: 'ai',
      timestamp: DateTime.now(),
      suggestionPills: suggestions,
    );
  }

  // Helper to determine if a query matches local keywords/db records
  bool _hasLocalMatch(
    String userText,
    List<Map<String, dynamic>> schemes,
    List<Map<String, dynamic>> rights,
  ) {
    final text = userText.toLowerCase().trim();

    // Check schemes
    for (final s in schemes) {
      final title = (s['title'] ?? '').toString().toLowerCase();
      if (text.contains(title) ||
          (title.contains('ladki bahin') && (text.contains('ladki') || text.contains('bahin'))) ||
          (title.contains('one stop') && (text.contains('sakhi') || text.contains('one stop') || text.contains('osc')))) {
        return true;
      }
    }

    // Check rights
    for (final r in rights) {
      final title = (r['title'] ?? '').toString().toLowerCase();
      if (text.contains(title) ||
          (title.contains('posh') && text.contains('posh')) ||
          (title.contains('domestic violence') && text.contains('domestic')) ||
          (title.contains('zero fir') && text.contains('zero fir')) ||
          (title.contains('sunset arrest') && text.contains('sunset'))) {
        return true;
      }
    }

    // Check other common local menu keywords
    final keywords = [
      'hi', 'hello', 'hey', 'greetings', 'how are you', 'who are you', 'your name',
      'created you', 'about yourself', 'sos', 'emergency', 'help', 'danger',
      'save me', 'police', 'fake call', 'call', 'exit', 'escape', 'live track',
      'track', 'share location', 'map', 'right', 'law', 'legal', 'ipc', 'crpc',
      'rights', 'laws', 'scheme', 'yojana', 'schemes', 'yojanas', 'welfare',
      'store', 'pepper', 'spray', 'flashlight', 'gear', 'product', 'circle',
      'guardian', 'parents', 'family', 'score', 'safety score', 'risk',
      'unsafe', 'hotspot'
    ];

    for (final kw in keywords) {
      if (text.contains(kw)) return true;
    }

    return false;
  }

  // Backup keyless AI responder
  Future<ChatMessage?> _getPollinationsResponse(String userText) async {
    try {
      final response = await http.get(
        Uri.parse('https://text.pollinations.ai/${Uri.encodeComponent(userText)}'),
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final reply = response.body.trim();
        if (reply.isNotEmpty) {
          return ChatMessage(
            id: 'ai_pollinations_${DateTime.now().millisecondsSinceEpoch}',
            text: reply,
            sender: 'ai',
            timestamp: DateTime.now(),
            suggestionPills: _getSuggestionsForText(reply),
          );
        }
      }
    } catch (e) {
      print("Pollinations API fallback failed: $e");
    }
    return null;
  }

  // Core AI response generator
  Future<ChatMessage> getAIResponse(
    String userText, {
    List<Map<String, dynamic>>? schemes,
    List<Map<String, dynamic>>? rights,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load preseeded data for fallback or enrichment
    List<Map<String, dynamic>> finalSchemes = schemes ?? [];
    List<Map<String, dynamic>> finalRights = rights ?? [];
    if (finalSchemes.isEmpty || finalRights.isEmpty) {
      try {
        final schemesJson = prefs.getStringList('mock_schemes') ?? [];
        if (finalSchemes.isEmpty) {
          finalSchemes = schemesJson.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
        }
        final rightsJson = prefs.getStringList('mock_rights') ?? [];
        if (finalRights.isEmpty) {
          finalRights = rightsJson.map((r) => jsonDecode(r) as Map<String, dynamic>).toList();
        }
      } catch (_) {}
    }

    // 1. If it matches a specific local feature/right/scheme, use local response directly
    if (_hasLocalMatch(userText, finalSchemes, finalRights)) {
      return _getLocalResponse(userText, finalSchemes, finalRights);
    }

    // 2. Otherwise (general question), try to use the Gemini API first
    String? apiKey = await getSavedApiKey();
    if (apiKey == null || apiKey.trim().isEmpty) {
      apiKey = _defaultApiKey;
    }

    // Find any matching scheme or right for context enrichment (RAG)
    String contextEnrichment = "";
    final lowerQuery = userText.toLowerCase();

    // Check schemes
    Map<String, dynamic>? matchedScheme;
    for (final s in finalSchemes) {
      final title = (s['title'] ?? '').toString().toLowerCase();
      if (lowerQuery.contains(title) || 
          (title.contains('ladki bahin') && (lowerQuery.contains('ladki') || lowerQuery.contains('bahin'))) ||
          (title.contains('one stop') && (lowerQuery.contains('sakhi') || lowerQuery.contains('one stop') || lowerQuery.contains('osc')))) {
        matchedScheme = s;
        break;
      }
    }

    // Check rights
    Map<String, dynamic>? matchedRight;
    for (final r in finalRights) {
      final title = (r['title'] ?? '').toString().toLowerCase();
      if (lowerQuery.contains(title) ||
          (title.contains('posh') && lowerQuery.contains('posh')) ||
          (title.contains('domestic violence') && lowerQuery.contains('domestic')) ||
          (title.contains('zero fir') && lowerQuery.contains('zero fir')) ||
          (title.contains('sunset arrest') && lowerQuery.contains('sunset'))) {
        matchedRight = r;
        break;
      }
    }

    if (matchedScheme != null) {
      contextEnrichment = "\n[Context: Here are the official details of the scheme mentioned: Title: ${matchedScheme['title']}, Description: ${matchedScheme['description']}, Eligibility: ${matchedScheme['eligibility']}, Application Steps: ${matchedScheme['applicationSteps'] ?? []}, Official URL: ${matchedScheme['officialUrl']}. Use these details in your answer.]\n";
    } else if (matchedRight != null) {
      contextEnrichment = "\n[Context: Here are the official details of the law mentioned: Title: ${matchedRight['title']}, Section: ${matchedRight['lawSection']}, Description: ${matchedRight['description']}, Penalty: ${matchedRight['penalty']}, Filing Process: ${matchedRight['filingProcess']}. Use these details in your answer.]\n";
    }

    if (apiKey.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'role': 'user',
                'parts': [
                  {
                    'text': "System Instruction: You are SHRI, a supportive AI assistant specialized in women's safety, legal rights, and government schemes in India. Be polite, concise, and helpful. Keep responses short and direct (under 3-4 sentences maximum). Offer safety-oriented advice.$contextEnrichment\n\nUser Question: $userText"
                  }
                ]
              }
            ]
          }),
        ).timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final aiText = data['candidates']?[0]?['content']?[0]?['text'] ?? 
                         data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
          if (aiText.isNotEmpty) {
            return ChatMessage(
              id: 'ai_gemini_${DateTime.now().millisecondsSinceEpoch}',
              text: aiText,
              sender: 'ai',
              timestamp: DateTime.now(),
              suggestionPills: _getSuggestionsForText(aiText),
            );
          }
        }
      } catch (e) {
        print("Gemini API call failed: $e. Trying Pollinations fallback...");
      }
    }

    // 3. Fallback: If Gemini is disabled or fails, try the free keyless Pollinations AI API
    final backupResponse = await _getPollinationsResponse(userText);
    if (backupResponse != null) {
      return backupResponse;
    }

    // 4. Offline Fallback: If even Pollinations fails, show local safety menu
    return _getLocalResponse(userText, finalSchemes, finalRights);
  }
}
