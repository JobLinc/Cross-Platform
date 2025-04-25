import 'package:dio/dio.dart';
import '../models/getmycompany_response.dart';

class CompanyApiService {
  final Dio dio;

  CompanyApiService(this.dio);

  Future<CompanyListResponse> getCurrentCompanies() async {
    try {
      final response = await dio.get('/user/companies',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));
      print('''
        === Received Response ===
        Status: ${response.statusCode} ${response.statusMessage}
        Headers: ${response.headers}
        Data: ${response.data}
        ''');

      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      if (response.data is List) {
        return CompanyListResponse.fromJson(response.data as List<dynamic>);
      } else {
        throw Exception('Expected a list of companies from API');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
