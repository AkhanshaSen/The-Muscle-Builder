class FoxChatMessage {
  const FoxChatMessage({
    required this.isUser,
    required this.text,
    required this.sentAt,
  });

  final bool isUser;
  final String text;
  final DateTime sentAt;

  Map<String, dynamic> toJson() => {
        'isUser': isUser,
        'text': text,
        'sentAt': sentAt.toIso8601String(),
      };

  factory FoxChatMessage.fromJson(Map<dynamic, dynamic> json) {
    final sentRaw = json['sentAt'];
    DateTime sentAt;
    if (sentRaw is String) {
      sentAt = DateTime.tryParse(sentRaw) ?? DateTime.now();
    } else {
      sentAt = DateTime.now();
    }
    return FoxChatMessage(
      isUser: json['isUser'] == true,
      text: (json['text'] as String?) ?? '',
      sentAt: sentAt,
    );
  }
}
