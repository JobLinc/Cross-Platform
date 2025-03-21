import 'package:dio/dio.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_service.dart';
import '../models/createcompany_response.dart';

class CreateCompanyApiService {
  final Dio _dio;

  CreateCompanyApiService(this._dio);

  Future<CreateCompanyResponse> createCompany(String name, String email,
      String phone, String industry, String overview) async {
    try {
      final authService = getIt<AuthService>();

      final accessToken = await authService.getAccessToken();
      print('Access Token: $accessToken');
      print(
          'Request Payload: {name: $name, email: $email, phone: $phone, industry: $industry, overview: $overview}');
      final response = await _dio.post(
        '/companies',
        options: Options(
          headers: {
            'authorization': accessToken,
          },
        ),
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
      print('API Error: ${e.message}');
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return 'Internal Server error ${e.response!.statusCode}   ${e.message}';
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
