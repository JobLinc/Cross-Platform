class Experience {
  final String experienceId;
  final String position;
  final String company;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;

  Experience({
    required this.experienceId,
    required this.position,
    required this.company,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
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

    DateTime start = parseDate(json['startDate']) ?? DateTime.now();
    DateTime? end = parseDate(json['endDate']) ?? DateTime.now();

    return Experience(
      experienceId: json['id'] ?? '',
      position: json['position'] ?? '',
      company: json['company'] ?? '',
      startDate: start,
      endDate: end,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'company': company,
      'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'description': description,
    };
  }
}
