import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/company_stats.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';

abstract class CompanyRepository {
  Future<List<Company>> getCurrentCompanies();
  Future<int> getCompanyCount();
  Future<List<Company>> getAllCompanies();
  Future<Company> getCompanyBySlug(String slug);
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
                IndustryExtension.fromDisplayName(companyResponse.industry) ??
                    Industry.technology,
            organizationSize: OrganizationSizeExtension.fromDisplayName(
                    companyResponse.size) ??
                OrganizationSize.elevenToFifty,
            organizationType: OrganizationTypeExtension.fromDisplayName(
                    companyResponse.type) ??
                OrganizationType.governmentAgency,
            overview: companyResponse.overview,
            website: companyResponse.website,
            logoUrl: companyResponse.logo,
            coverUrl: companyResponse.coverPhoto,
            followers: companyResponse.followers ?? 0,
            id: companyResponse.id);
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

  @override
  Future<List<Company>> getAllCompanies() async {
    try {
      final companyListResponse = await apiService.getAllCompanies();
      final companies = companyListResponse.companies
          .map((companyResponse) {
            try {
              return Company(
                name: companyResponse.name ?? 'Name not available',
                profileUrl: companyResponse.urlSlug ?? 'URL slug not available',
                industry: companyResponse.industry != null
                    ? (IndustryExtension.fromDisplayName(
                            companyResponse.industry.replaceAll('–', '-')) ??
                        Industry.technology)
                    : Industry.technology,
                organizationSize: companyResponse.size != null
                    ? (OrganizationSizeExtension.fromDisplayName(
                            companyResponse.size.replaceAll('–', '-')) ??
                        OrganizationSize.elevenToFifty)
                    : OrganizationSize.elevenToFifty,
                organizationType: companyResponse.type != null
                    ? (OrganizationTypeExtension.fromDisplayName(
                            companyResponse.type.replaceAll('–', '-')) ??
                        OrganizationType.privatelyHeld)
                    : OrganizationType.privatelyHeld,
                overview: companyResponse.overview ?? '',
                website: companyResponse.website ?? 'Website not available',
                logoUrl: companyResponse.logo ?? '',
                id: companyResponse.id ?? '',
                coverUrl: companyResponse.coverPhoto ?? '',
                followers: companyResponse.followers ?? 0,

              );
            } catch (e) {
              print('Error mapping company: ${companyResponse.toString()}');
              print('Error details: $e');
              return null;
            }
          })
          .where((c) => c != null)
          .cast<Company>()
          .toList();
      return companies;
    } catch (e, stack) {
      print('Error in getAllCompanies catch: $e');
      print('Stack trace: $stack');
      throw Exception('Failed to get all companies: $e');
    }
  }

  @override
  Future<Company> getCompanyBySlug(String slug) async {
    try {
      final companyListResponse = await apiService.getAllCompanies();
      final company = companyListResponse.companies.firstWhere(
        (company) => company.urlSlug == slug,
        orElse: () => throw Exception('Company not found'),
      );
      return Company(
          name: company.name,
          profileUrl: company.urlSlug,
          industry: IndustryExtension.fromDisplayName(company.industry)!,
          organizationSize:
              OrganizationSizeExtension.fromDisplayName(company.size)!,
          organizationType:
              OrganizationTypeExtension.fromDisplayName(company.type)!,
          overview: company.overview,
          website: company.website,
          logoUrl: company.logo,
          id: company.id,
          coverUrl: company.coverPhoto,
          followers: company.followers ?? 0,

          );
    } catch (e) {
      throw Exception('Failed to get company by slug: $e');
    }
  }

  Future<CompanyStats> getCompanyStats() {
    try {
      final companyStats = apiService.getCompanyStats();
      return companyStats;
    } catch (e) {
      throw Exception('Failed to get company stats: $e');
    }
  }
}
