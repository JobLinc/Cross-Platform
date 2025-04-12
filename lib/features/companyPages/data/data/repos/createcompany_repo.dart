import 'package:joblinc/features/companypages/data/data/services/createcompany_api_service.dart';

class CreateCompanyRepo {
  final CreateCompanyApiService _createCompanyApiService;

  CreateCompanyRepo(this._createCompanyApiService);

  Future<void> createCompany({
    required String name,
    required String urlSlug,
    required String industry,
    required String size,
    required String type,
    required String overview,
    required String website,
  }) async {
    await _createCompanyApiService.createCompany(
        name, urlSlug, industry, size, type, overview, website);
  }
}
