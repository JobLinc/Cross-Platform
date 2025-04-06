import 'package:dio/dio.dart';
import '../models/login_response.dart';

class LoginApiService {
  final Dio _dio;

  LoginApiService(this._dio);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Throw the error message directly instead of wrapping in Exception
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      // Try to extract the error message from the response
      // if (e.response?.data != null && e.response?.data['message'] != null) {
      //   return e.response?.data['message'];
      // }

      switch (e.response?.statusCode) {
        case 400:
          return 'Incorrect credentials. Please try again.';
        case 401:
          return 'Incorrect credentials. Please try again.';
        case 403:
          return 'Access denied';
        case 404:
          return 'The requested resource was not found';
        case 500:
          return 'Internal server error. Please try again later.';
        default:
          return 'Server error (${e.response?.statusCode})';
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Network error. Please check your internet connection.';
    }
    return 'An unexpected error occurred: ${e.message}';
  }
}
