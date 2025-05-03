import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/company_stats.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';

abstract class CompanyRepository {
  Future<List<Company>> getCurrentCompanies();
  Future<int> getCompanyCount();
  Future<List<Company>> getAllCompanies();
  Future<Company> getCompanyBySlug(String slug);
  Future<Company> getCompanyById(String id);
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
            industry: companyResponse.industry,
            organizationSize: companyResponse.size,
            organizationType: companyResponse.type,
            overview: companyResponse.overview,
            website: companyResponse.website,
            logoUrl: companyResponse.logo,
            coverUrl: companyResponse.coverPhoto,
            followers: companyResponse.followers ?? 0,
            id: companyResponse.id,
            locations: companyResponse.locations,
            isFollowing: true,
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
                industry: companyResponse.industry ,
                organizationSize: companyResponse.size ,
                organizationType: companyResponse.type ,
                overview: companyResponse.overview ?? 'Overview not available',
                website: companyResponse.website.contains("linkedin.com")
                    ? 'Website not available'
                    : companyResponse.website,
                logoUrl: companyResponse.logo ?? '',
                id: companyResponse.id,
                coverUrl: companyResponse.coverPhoto ?? '',
                followers: companyResponse.followers ?? 0,
                locations: companyResponse.locations,
                isFollowing: companyResponse.isFollowing!,
              );
            } catch (e) {
              return null;
            }
          })
          .where((c) => c != null)
          .cast<Company>()
          .toList();
      return companies;
    } catch (e) {
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
        industry: company.industry,
        organizationSize:
            company.size,
        organizationType:
            company.type,
        overview: company.overview,
        website: company.website,
        logoUrl: company.logo,
        id: company.id,
        coverUrl: company.coverPhoto,
        followers: company.followers ?? 0,
        locations: company.locations,
        isFollowing: company.isFollowing!
      );
    } catch (e) {
      throw Exception('Failed to get company by slug: $e');
    }
  }

  @override
  Future<Company> getCompanyById(String id) async {
    try {
      final companyResponse = await apiService.getCompanyById(id);
      return Company(
        name: companyResponse.name,
        profileUrl: companyResponse.urlSlug,
        industry: companyResponse.industry,
        organizationSize:
            companyResponse.size,
        organizationType:
            companyResponse.type,
        overview: companyResponse.overview,
        website: companyResponse.website,
        logoUrl: companyResponse.logo,
        id: companyResponse.id,
        coverUrl: companyResponse.coverPhoto,
        followers: companyResponse.followers ?? 0,
        locations: companyResponse.locations,
        isFollowing: companyResponse.isFollowing!,
      );
    } catch (e) {
      throw Exception('Failed to get company by id: $e');
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
