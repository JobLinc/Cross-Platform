import 'package:dio/dio.dart';
import '../models/update_user_profile_model.dart';

class UpdateUserProfileApiService {
  final Dio _dio;

  UpdateUserProfileApiService(this._dio);

  /// Update user's personal information
  /// Only sends the fields that are provided (non-null)
  Future<void> updateUserPersonalInfo(UserProfileUpdateModel updateData) async {
    try {
      print("=== Updating User Profile ===");
      print("Endpoint: /user/edit/personal-info");
      print("Method: PUT");
      print("Data: ${updateData.toJson()}");

      final response = await _dio.put(
        '/user/edit/personal-info',
        data: updateData.toJson(),
      );

      print("=== Profile Updated Successfully ===");
      print("Response: ${response.statusCode}");

      if (response.statusCode != 200) {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      print("=== Profile Update Error ===");
      print("Error: $e");
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }
}
 