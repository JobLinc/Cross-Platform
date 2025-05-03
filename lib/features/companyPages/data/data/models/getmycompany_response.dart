import 'package:joblinc/features/companypages/data/data/models/location_model.dart';

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
  final String? coverPhoto;
  final int? followers;
  final int? employees;
  final String? createdAt;
  final bool? isFollowing;
  final List <CompanyLocationModel>? locations;

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
    this.coverPhoto,
    this.followers,
    this.employees,
    this.createdAt,
    this.locations,
    required this.isFollowing,
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
      coverPhoto: json['coverPhoto'] ?? 'https://thingscareerrelated.com/wp-content/uploads/2021/10/default-background-image.png',
      followers: json['followers'],
      employees: json['employees'],
      createdAt: json['createdAt'],
      isFollowing: json['isFollowing'],
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => CompanyLocationModel.fromJson(e))
          .toList(),
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
