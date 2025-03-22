import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/changepassword/data/services/change_password_api_service.dart';

class ChangePasswordRepo {
  final ChangePasswordApiService _changePasswordApiService;

  ChangePasswordRepo(this._changePasswordApiService);

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final AuthService authService = getIt<AuthService>();
    final String? refreshToken = await authService.getRefreshToken();

    if (refreshToken == null) {
      throw Exception("Please log in again.");
    }

    final data = await _changePasswordApiService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      refreshToken: refreshToken,
    );
    authService.saveTokens(
        accessToken: data['accessToken'], refreshToken: data['refreshToken']);
  }
}
