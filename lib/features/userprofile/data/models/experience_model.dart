class Experience {
  final String experienceId;
  final String title;
  final String company;
  final int startYear;
  final int? endYear;
  final String description;

  Experience({
    required this.experienceId,
    required this.title,
    required this.company,
    required this.startYear,
    this.endYear,
    required this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      experienceId: json['experienceId'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      startYear: json['startYear'] ?? 0,
      endYear: json['endYear'],
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experienceId': experienceId,
      'title': title,
      'company': company,
      'startYear': startYear,
      if (endYear != null) 'endYear': endYear,
      'description': description,
    };
  }
}
