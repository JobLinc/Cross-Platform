import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/signup/data/models/register_request_model.dart';
import 'package:joblinc/features/signup/data/services/register_api_service.dart';

class RegisterRepo {
  final RegisterApiService _registerApiService;

  RegisterRepo(this._registerApiService);

  Future<void> register(RegisterRequestModel req) async {
    final response = await _registerApiService.register(req);
    final AuthService authService = getIt<AuthService>();
    await authService.saveAuthInfo(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.userId,
        role: response.role,
        confirmed: response.confirmed,
        email: req.email
        );
  }
}
