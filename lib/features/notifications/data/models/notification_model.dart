class NotificationModel {
  final String id;
  final String type;
  final String content;
  final String? imageUrl;
  final String isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.content,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? '',
      content: json['text'] ?? json['content'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'],
      isRead: json['status'] ?? "pending",
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'imageUrl': imageUrl,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
