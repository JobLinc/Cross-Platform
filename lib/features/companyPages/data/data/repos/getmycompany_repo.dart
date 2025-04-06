import 'package:joblinc/features/companyPages/data/data/company.dart';
import 'package:joblinc/features/companyPages/data/data/services/getmycompany.dart';

abstract class CompanyRepository {
  Future<Company> getCurrentCompany();
}

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyApiService apiService;

  CompanyRepositoryImpl(this.apiService);

  @override
  Future<Company> getCurrentCompany() async {
  try {
    final companyResponse = await apiService.getCurrentCompany();
    final company = Company(
      name: companyResponse.name,
      profileUrl: companyResponse.urlSlug,
      industry: IndustryExtension.fromDisplayName(companyResponse.industry)!,
      organizationSize: OrganizationSizeExtension.fromDisplayName(companyResponse.size)!,
      organizationType: OrganizationTypeExtension.fromDisplayName(companyResponse.type)!,
      overview: companyResponse.overview,
      website: companyResponse.website,
      logoUrl: companyResponse.profilePictureUrl,
    );
    return company; 
  } catch (e) {
    throw Exception('Failed to get company: $e');
  }
}
}

