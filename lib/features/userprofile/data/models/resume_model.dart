class Resume {
  final String id;
  final String name;
  final String file;
  final String type;
  final int size;
  final String userId;
  final DateTime createdAt;

  Resume({
    required this.id,
    required this.name,
    required this.file,
    required this.type,
    required this.size,
    required this.userId,
    required this.createdAt,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          print('Error parsing date: $dateValue - $e');
          return null;
        }
      }
      return null;
    }

    return Resume(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      file: json['file'] as String? ?? '',
      type: json['type'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      userId: json['userId'] as String? ?? '',
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
    );
  }
}
