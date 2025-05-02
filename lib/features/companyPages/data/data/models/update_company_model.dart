import 'location_model.dart'; // Import the locations model

class UpdateCompanyModel {
  final String? name;
  final String? phone;
  final String? industry;
  final String? size;
  final String? type;
  final String? tagline;
  final String? urlSlug;
  final String? workplace;
  final String? overview;
  final String? logo;
  final String? coverPhoto;
  final String? founded;
  final String? website;
  final List<CompanyLocationModel>? locations;

  UpdateCompanyModel({
    this.name,
    this.phone,
    this.industry,
    this.size,
    this.type,
    this.tagline,
    this.urlSlug,
    this.workplace,
    this.overview,
    this.logo,
    this.coverPhoto,
    this.founded,
    this.website,
    this.locations,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (industry != null) data['industry'] = industry;
    if (size != null) data['size'] = size;
    if (type != null) data['type'] = type;
    if (tagline != null) data['tagline'] = tagline;
    if (urlSlug != null) data['urlSlug'] = urlSlug;
    if (workplace != null) data['workplace'] = workplace;
    if (overview != null) data['overview'] = overview;
    if (logo != null) data['logo'] = logo;
    if (coverPhoto != null) data['coverPhoto'] = coverPhoto;
    if (founded != null) data['founded'] = founded;
    if (website != null) data['website'] = website;
    if (locations != null) {
      data['locations'] = locations!.map((loc) => loc.toJson()).toList();
    }
    return data;
  }
}
