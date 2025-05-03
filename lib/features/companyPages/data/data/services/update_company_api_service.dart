import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import '../models/update_company_model.dart';

class UpdateCompanyApiService {
  final Dio _dio;

  UpdateCompanyApiService(this._dio);

  Future<void> updateCompany(UpdateCompanyModel updateModel) async {
    try {
      await _dio.patch(
        '/companies',
        data: updateModel.toJson(),
      );
      return;
    } on DioException catch (e) {
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
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  Future<dynamic> removeCompanyLogo() async {
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

  Future<dynamic> removeCompanyCover() async {
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

  Future<dynamic> updateCompanyLocations(
      List<Map<String, dynamic>> locations) async {
    try {
      final response = await _dio.patch(
        '/companies',
        data: {'locations': locations},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message']);
      }
      throw Exception('Failed to update company locations: ${e.message}');
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
