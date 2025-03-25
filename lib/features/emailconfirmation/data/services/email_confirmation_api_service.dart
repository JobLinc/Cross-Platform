import 'package:dio/dio.dart';
import '../models/send_confirmation_email_request.dart';
import '../models/send_confirmation_email_response.dart';
import '../models/confirm_email_request.dart';
import '../models/confirm_email_response.dart';

class EmailConfirmationApiService {
  final Dio _dio;

  EmailConfirmationApiService(this._dio);

  Future<SendConfirmationEmailResponse> sendConfirmationEmail(
      SendConfirmationEmailRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/send-confirmation-email',
        data: request.toJson(),
      );

      return SendConfirmationEmailResponse.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Unexpected error occurred');
    }
  }

  Future<ConfirmEmailResponse> confirmEmail(ConfirmEmailRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/confirm-email',
        data: request.toJson(),
      );
      print(response.data);
      ConfirmEmailResponse res = ConfirmEmailResponse.fromJson(response.data);
      print(res);
      return ConfirmEmailResponse.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Unexpected error occurred');
    }
  }

  String _handleDioError(DioException e) {
    // No response: This is likely a network issue
    if (e.response == null) {
      return 'Network error! please try again';
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
        return 'Unauthorized request';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Requested resource not found';
      case 409:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'Conflict with current state';
      case 500:
        return 'Internal server error';
      default:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'Something went wrong. Please try again later.';
    }
  }
}
