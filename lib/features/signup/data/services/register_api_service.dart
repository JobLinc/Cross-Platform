import 'package:dio/dio.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class RegisterApiService {
  final Dio _dio;

  RegisterApiService(this._dio);

  Future<RegisterResponse> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Throw the error message directly instead of wrapping in Exception
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      // Try to extract the error message from the response
      if (e.response?.data != null && e.response?.data['message'] != null) {
        return e.response?.data['message'];
      }

      switch (e.response?.statusCode) {
        case 400:
          return 'Invalid registration data. Please check your input.';
        case 409:
          return 'This email is already registered.';
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
