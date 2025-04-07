class CompanyResponse {
  final String id;
  final String name;
  final String? profilePictureUrl;
  final String urlSlug;
  final String industry;
  final String size;
  final String type;
  final String overview;
  final String website;

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
    final requiredFields = ['name', 'urlSlug', 'industry', 'size', 'type'];
    for (final field in requiredFields) {
      if (json[field] == null) {
        throw FormatException('Missing required field: $field');
      }
    }
    return CompanyResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilePictureUrl: json['profilePictureUrl'],
      urlSlug: json['urlSlug'] ?? '',
      industry: json['industry'] ?? '',
      size: json['size'] ?? 'Unknown Size',
      type: json['type'] ?? 'Unknown Typw',
      overview: json['overview'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profilePictureUrl': profilePictureUrl,
        'urlSlug': urlSlug,
        'industry': industry,
        'size': size,
        'type': type,
        'overview': overview,
        'website': website,
      };
}
