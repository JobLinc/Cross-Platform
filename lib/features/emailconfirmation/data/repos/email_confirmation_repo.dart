import 'package:joblinc/features/emailconfirmation/data/services/email_confirmation_api_service.dart';

class EmailConfirmationRepo {
  final EmailConfirmationApiService _apiService;

  EmailConfirmationRepo(this._apiService);

  Future<String> resendConfirmationEmail(String email) async {
    final response = await _apiService.sendConfirmationEmail(email);
    return response['token'] ?? '';
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String token,
    required String otp,
  }) async {
    return await _apiService.confirmEmail(
      email: email,
      token: token,
      otp: otp,
    );
  }

  Future<bool> checkEmailConfirmationStatus(String userId) async {
    return await _apiService.checkEmailConfirmationStatus(userId);
  }
}
