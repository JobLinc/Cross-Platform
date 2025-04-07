import 'package:dio/dio.dart';
import '../models/company_model.dart';

class CompanyApiService {
  final Dio dio;

  CompanyApiService(this.dio);

  Future<CompanyResponse> getCurrentCompany() async {
    try {
      final response = await dio.get('/companies/me');

      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      try {
        return CompanyResponse.fromJson(response.data as Map<String, dynamic>);
      } on FormatException catch (e) {
        throw Exception('Invalid data format: ${e.message}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
