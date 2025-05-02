class CompanyStats {
  final int totalJobsCount;
  final int totalApplicantsCount;
  final int acceptedApplicantsCount;
  final int rejectedApplicantsCount;

  CompanyStats({
    required this.totalJobsCount,
    required this.totalApplicantsCount,
    required this.acceptedApplicantsCount,
    required this.rejectedApplicantsCount,
  });

  factory CompanyStats.fromJson(Map<String, dynamic> json) {
    return CompanyStats(
      totalJobsCount: json['totalJobsCount'] as int,
      totalApplicantsCount: json['totalApplicantsCount'] as int,
      acceptedApplicantsCount: json['acceptedApplicantsCount'] as int,
      rejectedApplicantsCount: json['rejectedApplicantsCount'] as int,
    );
  }
}
