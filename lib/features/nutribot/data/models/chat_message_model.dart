class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageModel({required this.id, required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id, 'text': text, 'isUser': isUser, 'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) => ChatMessageModel(
    id: map['id'] ?? '', text: map['text'] ?? '', isUser: map['isUser'] ?? false,
    timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : null,
  );
}
