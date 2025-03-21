import 'package:dio/dio.dart';

class ChangePasswordApiService {
  final Dio _dio;
  ChangePasswordApiService(this._dio);

  Future<void> changePassword(String oldPassword, String newPassword, String refreshToken) async{
    try{
      await _dio.post('/auth/change-password', data: { 'oldPassword': oldPassword,
    'newPassword': newPassword,
    'refreshToken': refreshToken
});}
on DioException catch (e) {
      throw (e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}

handleDioError(DioException e) {
  if (e.response != null) {
    if (e.response?.statusCode == 401) {
      return 'Incorrect credentials';
    } else {
      return 'internal Server error}';
    }
  } else {
    return 'Network error: ${e.message}';
  }
}