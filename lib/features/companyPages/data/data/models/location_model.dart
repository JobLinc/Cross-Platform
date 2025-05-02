class CompanyLocationModel {
  final String? address;
  final String? city;
  final String? country;
  final String? primary;

  CompanyLocationModel({
    this.address,
    this.city,
    this.country,
    this.primary,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (address != null) data['address'] = address;
    if (city != null) data['city'] = city;
    if (country != null) data['country'] = country;
    if (primary != null) data['primary'] = primary;
    return data;
  }

  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      primary: json['primary'] as String?,
    );
  }
}
