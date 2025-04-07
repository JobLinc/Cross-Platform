import 'package:joblinc/features/changeemail/data/services/change_email_api_service.dart';

class ChangeEmailRepo {
  final ChangeEmailApiService _changeEmailApiService;

  ChangeEmailRepo(this._changeEmailApiService);

  /// Updates the user's email address
  Future<Map<String, dynamic>> updateEmail(String newEmail) async {
    try {
      return await _changeEmailApiService.updateEmail(newEmail);
    } catch (e) {
      // Re-throw the exception to be handled by the Cubit
      rethrow;
    }
  }
}
