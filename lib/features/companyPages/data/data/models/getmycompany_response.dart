import '../company.dart';

List<Company> allCompanies = [];

class CompanyResponse {
  final String id;
  final String name;
  final String urlSlug;
  final String industry;
  final String size;
  final String type;
  final String overview;
  final String website;
  final String? logo;
  final int? followers;
  final int? employees;
  final String? createdAt;

  CompanyResponse({
    required this.id,
    required this.name,
    required this.urlSlug,
    required this.industry,
    required this.size,
    required this.type,
    required this.overview,
    required this.website,
    this.logo,
    this.followers,
    this.employees,
    this.createdAt,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      urlSlug: json['urlSlug'] ?? '',
      industry: json['industry'] ?? '',
      size: json['size'] ?? '',
      type: json['type'] ?? '',
      overview: json['overview'] ?? '',
      website: json['website'] ?? '',
      logo: (json['logo'] ??
          json['profilePictureUrl'] ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfphRB8Syzj7jIYXedFOeVZwicec0QaUv2cBwPc0l7NnXdjBKpoL9nDSeX46Tich1Razk&usqp=CAU'),
      followers: json['followers'],
      employees: json['employees'],
      createdAt: json['createdAt'],
    );
  }
}

class CompanyListResponse {
  final List<CompanyResponse> companies;
  final int count;

  CompanyListResponse({
    required this.companies,
    required this.count,
  });

  factory CompanyListResponse.fromJson(List<dynamic> jsonList) {
    final companies = jsonList.map((e) => CompanyResponse.fromJson(e)).toList();
    return CompanyListResponse(
      companies: companies,
      count: companies.length,
    );
  }
}
