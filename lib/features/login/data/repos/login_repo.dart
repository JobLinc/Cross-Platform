import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/login/data/services/login_api_service.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/login/data/models/login_response_model.dart';

class LoginRepo {
  final LoginApiService _loginApiService;

  LoginRepo(this._loginApiService);

  Future<LoginResponseModel> login(String email, String password) async {
    final response = await _loginApiService.login(email, password);
    final AuthService authService = getIt<AuthService>();

    // Pass all fields to saveAuthInfo
    await authService.saveAuthInfo(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.userId,
      role: response.role,
      email: response.email,
      confirmed: response.confirmed,
    );

    return response;
  }
}
