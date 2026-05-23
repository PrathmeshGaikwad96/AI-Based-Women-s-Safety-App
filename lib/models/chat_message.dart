class ChatMessage {
  final String id;
  final String text;
  final String sender; // 'user' or 'ai'
  final DateTime timestamp;
  final List<String> suggestionPills;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.suggestionPills = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'suggestionPills': suggestionPills,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      sender: map['sender'] ?? 'user',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      suggestionPills: List<String>.from(map['suggestionPills'] ?? []),
    );
  }
}
