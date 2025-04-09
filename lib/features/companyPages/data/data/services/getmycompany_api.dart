import 'package:dio/dio.dart';
import 'package:joblinc/features/companyPages/data/data/models/getmycompany_response.dart';

class CompanyApiService {
  final Dio _dio;

  CompanyApiService(this._dio);

  Future<CompanyResponse> getCurrentCompany() async {
    try {
      final response = await _dio.get(
        '/companies/me',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return CompanyResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return 'Server error ${e.response!.statusCode}: ${e.response!.data['message'] ?? e.response!.statusMessage}';
    }
    return 'Network error: ${e.message}';
  }
}