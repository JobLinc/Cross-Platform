import 'package:dio/dio.dart';

class ChangeEmailApiService {
  final Dio _dio;

  ChangeEmailApiService(this._dio);

  /// Updates the user's email
  Future<Map<String, dynamic>> updateEmail(String newEmail) async {
    try {
      final response = await _dio.put(
        '/user/edit/email',
        data: {'email': newEmail},
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw 'Failed to update email';
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
