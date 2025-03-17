import 'package:dio/dio.dart';
import 'package:joblinc/features/signup/data/models/register_response_model.dart';
import '../models/register_request_model.dart';

class RegisterApiService {
  final Dio _dio;

  RegisterApiService(this._dio);

  Future<RegisterResponse> register(
      RegisterRequestModel registerRequestModel) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: registerRequestModel.toJson(),
      );
      print(response.data);
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 400) {
        return e.response?.statusMessage?.toString() ?? 'Invalid data';
      } else if (e.response?.statusCode == 409) {
        return 'User already exists';
      } else {
        return 'Internal Server Error';
      }
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
