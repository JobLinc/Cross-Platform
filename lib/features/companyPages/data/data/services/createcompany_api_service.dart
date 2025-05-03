import 'package:dio/dio.dart';
import '../models/createcompany_response.dart';

class CreateCompanyApiService {
  final Dio _dio;

  CreateCompanyApiService(this._dio);

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final responseData = e.response?.data;
      if (responseData is Map && responseData.containsKey('message')) {
        return responseData['message'] as String;
      }
      return 'Server error ${e.response!.statusCode}: ${e.response!.statusMessage}';
    } else {
      return 'Network error: ${e.message}';
    }
  }

  Future<CreateCompanyResponse> createCompany(
    String name,
    String urlSlug,
    String industry,
    String size,
    String type,
    String overview,
    String website,
  ) async {
    try {
      final response = await _dio.post(
        '/companies',
        data: {
          'name': name,
          'urlSlug': urlSlug,
          'industry': industry,
          'size': size,
          'type': type,
          'overview': overview,
          'website': website,
        },
      );
      return CreateCompanyResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        final message = _handleDioError(e);
        throw Exception(message); // <-- Throw only the message
      }
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
