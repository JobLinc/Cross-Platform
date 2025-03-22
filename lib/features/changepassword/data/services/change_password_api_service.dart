import 'package:dio/dio.dart';

class ChangePasswordApiService {
  final Dio _dio;

  ChangePasswordApiService(this._dio);

  Future<dynamic> changePassword({
    required String oldPassword,
    required String newPassword,
    required String refreshToken,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/change-password',
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
          "refreshToken": refreshToken,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error occurred');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response == null) {
      return 'Network error! Please try again';
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String backendMessage = '';

    if (data is Map<String, dynamic>) {
      backendMessage = data['message']?.toString() ?? '';
    } else if (data is String) {
      backendMessage = data;
    }

    switch (statusCode) {
      case 400:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'Invalid input data';
      case 401:
        print(e.response?.data["errorCode"]);
        return 'Unauthorized request';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Requested resource not found';
      case 500:
        return 'Internal server error';
      default:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'Something went wrong. Please try again later.';
    }
  }
}
