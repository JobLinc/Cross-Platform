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
    return Certification(
      certificationId: json['_id'] ?? '',
      name: json['name'] ?? '',
      organization: json['organization'] ?? '',
      startYear: json['issueDate'] ?? 0,
      endYear: json['expirationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'organization': organization,
      'issueDate': startYear.toString(),
      if (endYear != null) 'expirationDate': endYear.toString(),
    };
  }
}
