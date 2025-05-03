import 'package:dio/dio.dart';
import 'package:joblinc/features/companypages/data/data/models/company_stats.dart';
import '../models/getmycompany_response.dart';
import '../models/company_id.dart';

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

      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      if (response.data is List) {
        final ids = (response.data as List)
            .map((json) => CompanyResponse.fromJson(json as Map<String, dynamic>).id)
            .toList();
        MyCompanyIds.instance.setCompanyIds(ids);

        return CompanyListResponse.fromJson(response.data as List<dynamic>);
      } else {
        throw Exception('Expected a list of companies from API');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

   Future<CompanyListResponse> getAllCompanies() async {
    try {
      final response = await dio.get('/companies',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      if (response.data is List) {
        return CompanyListResponse.fromJson(response.data as List<dynamic>);
      } else {
        throw Exception('Expected a list of all companies from API');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<CompanyResponse> getCompanyById(String id) async {
    try {
      final response = await dio.get('/companies?id=$id',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));
      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      // Fix: handle if response.data is a List with one company
      if (response.data is List && (response.data as List).isNotEmpty) {
        return CompanyResponse.fromJson((response.data as List).first as Map<String, dynamic>);
      } else if (response.data is Map<String, dynamic>) {
        return CompanyResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Unexpected response format for getCompanyById');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<CompanyStats> getCompanyStats() async {
    try {
      final response = await dio.get('/companies/stats',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));
      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }
      return CompanyStats.fromJson(response.data as Map<String, dynamic>);

    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
