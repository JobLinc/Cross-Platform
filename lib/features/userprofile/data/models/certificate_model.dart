class Certification {
  final String certificationId;
  final String name;
  final String organization;
  final int startYear;
  final int? endYear;

  Certification({
    required this.certificationId,
    required this.name,
    required this.organization,
    required this.startYear,
    this.endYear,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      certificationId: json['certificationId'] ?? '',
      name: json['name'] ?? '',
      organization: json['organization'] ?? '',
      startYear: json['startYear'] ?? 0,
      endYear: json['endYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificationId': certificationId,
      'name': name,
      'organization': organization,
      'startYear': startYear,
      if (endYear != null) 'endYear': endYear,
    };
  }
}