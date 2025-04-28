import 'package:dio/dio.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

class OthersApiService {
  final Dio _dio;

  OthersApiService(this._dio);

  Future<UserProfile> getPublicUserProfile(String userId) async {
    try {
      final response = await _dio.get('/user/u/$userId/public');
      print(response.data);
      return UserProfile.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw Exception('Unexpected error: $e');
    }
  }
}
