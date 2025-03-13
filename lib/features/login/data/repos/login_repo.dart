import 'package:joblinc/features/login/data/services/login_api_service.dart';
import 'package:joblinc/features/login/data/services/securestorage_service.dart';

class LoginRepo {
  final LoginApiService _loginApiService;

  LoginRepo(this._loginApiService);

  Future<void> login(String email, String password) async {
    final response = await _loginApiService.login(email, password);
 
    await SecureStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
  }
}
