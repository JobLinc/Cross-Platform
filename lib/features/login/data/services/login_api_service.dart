import 'package:dio/dio.dart';
import 'package:joblinc/features/login/data/models/login_response_model.dart';

class LoginApiService {
  final Dio _dio;

  LoginApiService(this._dio);

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Handle error response
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Login failed';
        throw message;
      }
      throw 'Connection error. Please check your internet connection.';
    }
  }
}
