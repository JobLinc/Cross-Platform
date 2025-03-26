class CreateCompanyRequestBody {
  final String addressUrl;
  final String name;
  final String overview;
  final String industry;
  final String size;
  final String type;
  String? website = "website";
  String? logo;
  String? coverPhoto;

  CreateCompanyRequestBody({
    required this.name,
    required this.addressUrl,
    required this.industry,
    required this.size,
    required this.type,
    required this.overview,
    this.logo,
    this.coverPhoto,
    this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "addressUrl": addressUrl,
      "industry": industry,
      "size": size,
      "type": type,
      "overview": overview,
      "website": website,
      "logo": "logo.png",
      "coverPhoto": "logo.png",
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
