// models/company_response.dart
class CompanyResponse {
  final String id;
  final String name;
  final String urlSlug;
  final String industry;
  final String size;
  final String type;
  final String overview;
  final String website;
  final String? profilePictureUrl;

  CompanyResponse({
    required this.id,
    required this.name,
    this.profilePictureUrl,
    required this.urlSlug,
    required this.industry,
    required this.size,
    required this.type,
    required this.overview,
    required this.website,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      id: json['id'],
      name: json['name'],
      urlSlug: json['urlSlug'],
      industry: json['industry'],
      size: json['size'],
      type: json['type'],
      overview: json['overview'],
      website: json['website'],
    );
  }
}
