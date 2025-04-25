import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';
import '../models/getmycompany_response.dart';

abstract class CompanyRepository {
  Future<List<Company>> getCurrentCompanies();
  Future<int> getCompanyCount();
}

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyApiService apiService;

  CompanyRepositoryImpl(this.apiService);

  @override
  Future<List<Company>> getCurrentCompanies() async {
    try {
      final companyListResponse = await apiService.getCurrentCompanies();
      final companies = companyListResponse.companies.map((companyResponse) {
        return Company(
          name: companyResponse.name,
          profileUrl: companyResponse.urlSlug,
          industry:
              IndustryExtension.fromDisplayName(companyResponse.industry)!,
          organizationSize:
              OrganizationSizeExtension.fromDisplayName(companyResponse.size)!,
          organizationType:
              OrganizationTypeExtension.fromDisplayName(companyResponse.type)!,
          overview: companyResponse.overview,
          website: companyResponse.website,
          logoUrl: companyResponse.profilePictureUrl,
        );
      }).toList();
      return companies;
    } catch (e) {
      throw Exception('Failed to get companies: $e');
    }
  }

  @override
  Future<int> getCompanyCount() async {
    try {
      final companyListResponse = await apiService.getCurrentCompanies();
      return companyListResponse.count;
    } catch (e) {
      throw Exception('Failed to get company count: $e');
    }
  }
}
