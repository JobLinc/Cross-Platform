class CompanyLocationModel {
  final String? address;
  final String? city;
  final String? country;
  final bool? primary;
  final String? id;

  CompanyLocationModel({
    this.address,
    this.city,
    this.country,
    this.primary,
    this.id,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (address != null) data['address'] = address;
    if (id != null) data['id'] = id;
    if (city != null) data['city'] = city;
    if (country != null) data['country'] = country;
    if (primary != null) data['primary'] = primary;
    return data;
  }

  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(
      id: json['id'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      primary: json['primary'] as bool?,
    );
  }
}
