class Message {
  final String message;
  final DateTime sentAt;
  final String sender;
  Message({
    required this.message,
    required this.sender,
    required this.sentAt,
  });
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json['message'],
        sender: json['sender'],
        sentAt: DateTime.fromMillisecondsSinceEpoch(json['sentAt'] * 1000),
      );
}
