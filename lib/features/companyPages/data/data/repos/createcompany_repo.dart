import 'package:joblinc/features/companyPages/data/data/services/createcompany_api_service.dart';

class CreateCompanyRepo {
  final CreateCompanyApiService _createCompanyApiService;

  CreateCompanyRepo(this._createCompanyApiService);

  Future<void> createCompany({
  required String name,
  required String addressUrl,
  required String industry,
  required String size,
  required String type,
  required String overview,
  required String website,
}) async {
  await _createCompanyApiService.createCompany(
    name, addressUrl, industry, size, type, overview, website
  );
}
}
