import 'package:dio/dio.dart';

class EmailConfirmationApiService {
  final Dio _dio;

  EmailConfirmationApiService(this._dio);

  /// Sends a verification email to the user
  /// Note: This requires authentication from the backend
  Future<Map<String, dynamic>> sendConfirmationEmail(String email) async {
    try {
      final response = await _dio
          .post('/auth/send-confirmation-email', data: {'email': email});
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Verifies the email with token and OTP
  /// Note: This requires authentication from the backend
  Future<Map<String, dynamic>> confirmEmail({
    required String email,
    required String token,
    required String otp,
  }) async {
    try {
      final response = await _dio.post('/auth/confirm-email', data: {
        'email': email,
        'token': token,
        'otp': otp,
      });

      // If verification is successful, update the auth info
      if (response.statusCode == 200) {
        return response.data;
      }

      throw 'Email verification failed';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Checks if the user's email is confirmed
  /// Note: This is not directly available in the backend but we can derive it from login response
  Future<bool> checkEmailConfirmationStatus(String userId) async {
    try {
      // Since the backend doesn't have a direct endpoint for this,
      // we'll need to use the user profile or other endpoint to check this
      // For now, we'll return a placeholder response
      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Error handler that extracts the backend message or returns a default error
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please try again later.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Unable to get response from the server. Please try again.';
    } else if (e.type == DioExceptionType.badResponse) {
      try {
        final responseData = e.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          return responseData['message'] ??
              'Unexpected error occurred. Please try again.';
        } else {
          return 'Unexpected error occurred. Please try again.';
        }
      } catch (e) {
        return 'Something went wrong parsing the error. Please try again.';
      }
    } else if (e.type == DioExceptionType.cancel) {
      return 'Request was cancelled. Please try again.';
    } else if (e.type == DioExceptionType.unknown) {
      return 'No internet connection. Please check your network.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
