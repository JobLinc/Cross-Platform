import 'package:dio/dio.dart';
import '../models/createcompany_response.dart';

class CreateCompanyApiService {
  final Dio _dio;

  CreateCompanyApiService(this._dio);

  Future<CreateCompanyResponse> createCompany(String name, String email, String phone, String industry, String overview ) async {
    try {
      final response = await _dio.post(
        '/companies',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'industry': industry,
          'overview': overview,
        },
      );
      print(response.data);
      return CreateCompanyResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return 'internal Server error}';
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
