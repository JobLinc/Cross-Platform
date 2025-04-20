class Certification {
  final String certificationId;
  final String name;
  final String organization;
  final DateTime startYear;
  final DateTime? endYear;

  Certification({
    required this.certificationId,
    required this.name,
    required this.organization,
    required this.startYear,
    this.endYear,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
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

    DateTime startDate = parseDate(json['issueDate']) ?? DateTime.now();
    DateTime? endDate = parseDate(json['expirationDate']) ?? DateTime.now();

    return Certification(
      certificationId: json['_id'] ?? '',
      name: json['name'] ?? '',
      organization: json['organization'] ?? '',
      startYear: startDate,
      endYear: endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'organization': organization,
      'issueDate': startYear.toIso8601String(),
      if (endYear != null) 'expirationDate': endYear!.toIso8601String(),
    };
  }
}
