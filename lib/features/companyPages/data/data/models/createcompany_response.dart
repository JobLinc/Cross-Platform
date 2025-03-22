class Location {
  final String address;
  final String city;
  final String country;
  final bool primary;
  final String id;

  Location({
    required this.address,
    required this.city,
    required this.country,
    required this.primary,
    required this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      city: json['city'],
      country: json['country'],
      primary: json['primary'],
      id: json['id'],
    );
  }
}

class CreateCompanyResponse {
  final String name;
  final String email;
  final String phone;
  final String industry;
  final String owner;
  // final String website;
  // final List<String> admins;
  // final String overview;
  // final String logo;
  // final String coverPhoto;
  // final DateTime founded;
  // final List<Location> locations;
  // final int followers;
  // final int employees;
  // final List<String> jobs;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final String id;

  CreateCompanyResponse({
    required this.name,
    required this.email,
    required this.phone,
    required this.industry,
    required this.owner,
    // required this.website,
    // required this.admins,
    // required this.overview,
    // required this.logo,
    // required this.coverPhoto,
    // required this.founded,
    // required this.locations,
    // required this.followers,
    // required this.employees,
    // required this.jobs,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.id,
  });

  factory CreateCompanyResponse.fromJson(Map<String, dynamic> json) {
    // var locationsFromJson = (json['locations'] as List)
    //     .map((location) => Location.fromJson(location))
    //     .toList();

    return CreateCompanyResponse(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      industry: json['industry'] ?? "",
      owner: json['owner'] ?? "",
      // website: json['website'] ?? "",
      // admins: List<String>.from(json['admins'] ?? "") ?? [""],
      // overview: json['overview'] ?? "",
      // logo: json['logo'] ?? "",
      // coverPhoto: json['coverPhoto'] ?? "",
      // founded: DateTime.parse(json['founded']) ?? DateTime(2),
      // locations: json['locations']
      //         .map<Location>((location) => Location.fromJson(location))
      //         .toList() ??
      //     "",
      // followers: json['followers'] ?? "",
      // employees: json['employees'] ?? "",
      // jobs: List<String>.from(json['jobs']?? "") ?? [""],
      // createdAt: DateTime.parse(json['createdAt']?? "") ?? DateTime(2),
      // updatedAt: DateTime.parse(json['updatedAt'] ?? "") ?? DateTime(2),
      // id: json['id'] ?? "",
    );
  }
}
