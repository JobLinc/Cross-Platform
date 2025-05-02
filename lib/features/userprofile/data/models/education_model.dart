class Education {
  final String educationId;
  final String degree;
  final String school;
  final String fieldOfStudy;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;
  final double? cgpa;

  Education({
    required this.educationId,
    required this.degree,
    required this.school,
    required this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.description,
    this.cgpa,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      educationId: json['id'] ?? '',
      degree: json['degree'] ?? '',
      school: json['school'] ?? '',
      fieldOfStudy: json['fieldOfStudy'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      description: json['description'],
      cgpa: json['CGPA'] != null
          ? double.tryParse(json['CGPA'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'school': school,
      'fieldOfStudy': fieldOfStudy,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (description != null) 'description': description,
      if (cgpa != null) 'CGPA': cgpa,
    };
  }
}
