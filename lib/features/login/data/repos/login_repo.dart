import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/login/data/services/login_api_service.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';

class LoginRepo {
  final LoginApiService _loginApiService;

  LoginRepo(this._loginApiService);

  Future<Map<String,dynamic>> login(String email, String password) async {
    final response = await _loginApiService.login(email, password);
    final AuthService authService = getIt<AuthService>();
    await authService.saveAuthInfo(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.userId,
        role: response.role,
        confirmed: response.confirmed,
        email: email
        );

    return {
      'confirmed': response.confirmed,
      'email': email
    };
  }
}
