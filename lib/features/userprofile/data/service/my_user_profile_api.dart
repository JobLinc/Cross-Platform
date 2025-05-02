import 'package:dio/dio.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import '../models/user_profile_model.dart';

class UserProfileApiService {
  final Dio _dio;

  UserProfileApiService(this._dio);

  Future<UserProfile> getUserProfile() async {
    try {
      print('=== Sending User Profile Request ===');
      print('Endpoint: /user/me');
      print('Method: GET');
      print('Headers: ${_dio.options.headers}');

      final response = await _dio.get('/user/me');

      print('=== Received User Profile Response ===');
      print('Status: ${response.statusCode} ${response.statusMessage}');
      print('Headers: ${response.headers}');
      print('Data: ${response.data}');
      UserService.saveUserDataFromJson(response.data);
      print('=== User Profile Data Saved ===');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      print('=== User Profile Request Failed ===');
      print('Error: $errorMessage');

      throw Exception(errorMessage);
    } catch (e) {
      print('=== Unexpected Error ===');
      print('Error: $e');

      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final responseData = e.response?.data;
      if (responseData is Map && responseData.containsKey('message')) {
        return responseData['message'] as String;
      }
      return 'Server error ${e.response!.statusCode}: ${e.response!.statusMessage}';
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
