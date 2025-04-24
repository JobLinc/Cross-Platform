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
      print('''
        === Sending Company Creation Request ===
        Endpoint: /companies
        Payload:
        - Name: $name
        - Address URL: $urlSlug
        - Industry: $industry
        - Size: $size
        - Type: $type
        - Overview: ${overview.length > 50 ? '${overview.substring(0, 50)}...' : overview}
        - Website: $website
        ''');
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
      print('''
        === Received Response ===
        Status: ${response.statusCode} ${response.statusMessage}
        Headers: ${response.headers}
        Data: ${response.data}
        ''');
      return CreateCompanyResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        final message = _handleDioError(e);
        print('API Error Message: $message');
        throw Exception(message); // <-- Throw only the message
      }
      rethrow;
    } catch (e) {
      print({
        "message": 'Unexpected error: $e',
        "errorCode": 500,
      });
      throw Exception('Unexpected error: $e');
    }
  }
}
