import 'package:joblinc/features/userprofile/data/models/update_user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/service/update_user_profile_api.dart';

class ChangeUsernameRepo {
  final UpdateUserProfileApiService _updateUserProfileApiService;

  ChangeUsernameRepo(this._updateUserProfileApiService);

  Future<void> changeUsername({
    required String newUsername,
  }) async {
    // Create update model with only the username field
    final updateData = UserProfileUpdateModel(username: newUsername);

    // Use the existing API service to update the username
    await _updateUserProfileApiService.updateUserPersonalInfo(updateData);
  }
}
