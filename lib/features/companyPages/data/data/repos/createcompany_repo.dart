import 'package:joblinc/features/companypages/data/data/models/createcompany_response.dart';
import 'package:joblinc/features/companypages/data/data/services/createcompany_api_service.dart';

class CreateCompanyRepo {
  final CreateCompanyApiService _api;

  CreateCompanyRepo(this._api);

  Future<CreateCompanyResponse> createCompany({
    required String name,
    required String urlSlug,
    required String industry,
    required String size,
    required String type,
    required String overview,
    required String website,
  }) {
    return _api.createCompany(
      name, urlSlug, industry, size, type, overview, website
    );
  }
}
