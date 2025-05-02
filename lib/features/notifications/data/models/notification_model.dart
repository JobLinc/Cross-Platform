class NotificationModel {
  final String id;
  final String type; // "react", "comment", "connection", "message"
  final String content;
  final String? imageUrl;
  final String isRead;
  final DateTime createdAt;
  final String? relatedEntityId; // Added from the documentation
  final String? subRelatedEntityId; // Added from the documentation

  NotificationModel({
    required this.id,
    required this.type,
    required this.content,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
    this.relatedEntityId,
    this.subRelatedEntityId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? '',
      content: json['text'] ?? json['content'] ?? '',
      imageUrl: json['imageURL'] ?? json['image'] ?? json['imageUrl'],
      isRead: json['status'] ?? "pending",
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      relatedEntityId: json['relatedEntityId'],
      subRelatedEntityId: json['subRelatedEntityId'],
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
      'relatedEntityId': relatedEntityId,
      'subRelatedEntityId': subRelatedEntityId,
    };
  }
}
