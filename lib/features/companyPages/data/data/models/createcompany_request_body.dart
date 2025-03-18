class CreateCompanyRequestBody {
  final String email;
  final String name;
  final String overview = "overview";
  final String industry;
  final String phone;
  String? website = "website";
  String? logo;
  String? coverPhoto;
  DateTime? founded;
  int? employees;

  CreateCompanyRequestBody({
    required this.email,
    required this.name,
    required this.industry,
    required this.phone,
    this.logo,
    this.coverPhoto,
    this.founded,
    this.employees,
    this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "industry": "test",
      "overview": overview,
      "website": website,
      "logo": "logo.png",
      "coverPhoto": "logo.png",
      "founded": "01-01-2001",
      "employees": 2000,
      // "locations": [
      //   {
      //     "address": "address",
      //     "city": "city",
      //     "country": "country",
      //     "primary": true,
      //   },
      //   {
      //     "address": "address",
      //     "city": "city",
      //     "country": "country",
      //   }
      // ]
    };
  }
}
