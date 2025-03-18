import 'package:joblinc/features/companyPages/data/data/services/createcompany_api_service.dart';
import 'package:joblinc/features/login/data/services/securestorage_service.dart';

class CreateCompanyRepo {
  final CreateCompanyApiService _createCompanyApiService;

  CreateCompanyRepo(this._createCompanyApiService);

  Future<void> createCompany(String name, String email, String phone, String industry, String overview) async {
    await _createCompanyApiService.createCompany(name, email, phone, industry, overview);
  }
}
