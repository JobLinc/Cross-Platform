import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import '../models/update_company_model.dart';

class UpdateCompanyApiService {
  final Dio _dio;

  UpdateCompanyApiService(this._dio);

  Future<void> updateCompany(UpdateCompanyModel updateModel) async {
    try {
      final response = await _dio.patch(
        '/companies',
        data: updateModel.toJson(),
      );
      print('''
        === Received Response ===
        Status: ${response.statusCode} ${response.statusMessage}
        Headers: ${response.headers}
        Data: ${response.data}
        ''');
      // Handle the response if needed
      // Optionally handle response if needed
      return;
    } on DioException catch (e) {
      // Optionally extract and throw a more specific error message
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message']);
      }
      throw Exception('Failed to update company: ${e.message}');
    }
  }

  Future<dynamic> uploadCompanyLogo(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      // Prepare FormData to send the file
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: getMediaType(imageFile),
        ),
      });

      // Upload the file and get the logo URL from the response
      Response uploadResponse = await _dio.patch(
        '/companies/change-logo',
        data: formData,
      );
      return uploadResponse.data;
      // Extract the logo URL from the response (adjust the key if needed)
      // final logoUrl = uploadResponse.data['logo'];
      // if (logoUrl == null) {
      //   throw Exception('Logo URL not found in response');
      // }

      // // Send PATCH request with {"logo": "logoUrl"}
      // Response response = await _dio.patch(
      //   '/companies',
      //   data: {'logo': logoUrl},
      // );

    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }
 Future<dynamic> uploadCompanyCover(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      // Prepare FormData to send the file
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: getMediaType(imageFile),
        ),
      });

      // Upload the file and get the logo URL from the response
      Response uploadResponse = await _dio.patch(
        '/companies/change-cover',
        data: formData,
      );
      return uploadResponse.data;
      // Extract the logo URL from the response (adjust the key if needed)
      // final logoUrl = uploadResponse.data['logo'];
      // if (logoUrl == null) {
      //   throw Exception('Logo URL not found in response');
      // }

      // // Send PATCH request with {"logo": "logoUrl"}
      // Response response = await _dio.patch(
      //   '/companies',
      //   data: {'logo': logoUrl},
      // );

    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  Future <dynamic> removeCompanyLogo() async {
    try {
      final response = await _dio.delete(
        '/companies/remove-logo',
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message']);
      }
      throw Exception('Failed to remove company logo: ${e.message}');
    }
  }

  Future <dynamic> removeCompanyCover() async {
    try {
      final response = await _dio.delete(
        '/companies/remove-cover',
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message']);
      }
      throw Exception('Failed to remove company logo: ${e.message}');
    }
  }

  MediaType getMediaType(File file) {
    final extension = file.path.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('application', 'octet-stream'); // Fallback
    }
  }
}
