import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/login/data/models/login_response_model.dart';
import 'package:joblinc/features/login/data/services/login_api_service.dart';

class LoginRepo {
  final LoginApiService _loginApiService;

  LoginRepo(this._loginApiService);

  Future<LoginResponseModel> login(String email, String password) async {
    final response = await _loginApiService.login(email, password);
    await _saveAuthInfo(response);
    return response;
  }

  Future<LoginResponseModel> loginWithGoogle() async {
    final response = await _loginApiService.loginWithGoogle();
    await _saveAuthInfo(response);
    return response;
  }

  Future<void> _saveAuthInfo(LoginResponseModel response) async {
    final AuthService authService = getIt<AuthService>();

    await authService.saveAuthInfo(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.userId,
      role: response.role,
      email: response.email,
      confirmed: response.confirmed,
    );
  }
}
