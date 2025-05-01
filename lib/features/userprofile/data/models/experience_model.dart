class ExperienceModel {
  final String experienceId;
  String? companyId;
  String? company;
  final String position;
  final DateTime startDate;
  final String? endDate;
  final String description;
  final String? mode;
  final String? type;

  ExperienceModel({
    required this.experienceId,
    this.companyId,
    this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.description,
    this.mode,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      if (company != null) 'company': company,
      if (companyId != null) 'companyId': companyId,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate ?? 'Present',
      'description': description,
      if (mode != null) 'mode': mode,
      if (type != null) 'type': type,
    };
  }
}

class ExperienceResponse {
  final String id;
  final CompanyInfo company;
  final String position;
  final DateTime startDate;
  final String endDate;
  final String description;
  String? mode;
  String? type;

  ExperienceResponse({
    required this.id,
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.mode,
    this.type,
  });

  factory ExperienceResponse.fromJson(Map<String, dynamic> json) {
    return ExperienceResponse(
      id: json['id'] ?? '',
      company: CompanyInfo.fromJson(json['company'] as Map<String, dynamic>),
      position: json['position'] ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] ?? '',
      description: json['description'] ?? '',
      mode: json['mode'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class CompanyInfo {
  final String name;
  final String logo;

  CompanyInfo({
    required this.name,
    required this.logo,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}
