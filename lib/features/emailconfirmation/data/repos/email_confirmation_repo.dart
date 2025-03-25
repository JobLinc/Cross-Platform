import '../models/send_confirmation_email_request.dart';
import '../models/send_confirmation_email_response.dart';
import '../models/confirm_email_request.dart';
import '../models/confirm_email_response.dart';
import '../services/email_confirmation_api_service.dart';

class EmailConfirmationRepo {
  final EmailConfirmationApiService _apiService;

  EmailConfirmationRepo(this._apiService);

  Future<SendConfirmationEmailResponse> sendConfirmationEmail(String email) {
    return _apiService
        .sendConfirmationEmail(SendConfirmationEmailRequest(email: email));
  }

  Future<ConfirmEmailResponse> confirmEmail(
      String email, String token, String otp) {
    return _apiService.confirmEmail(
        ConfirmEmailRequest(email: email, token: token, otp: otp));
  }
}
