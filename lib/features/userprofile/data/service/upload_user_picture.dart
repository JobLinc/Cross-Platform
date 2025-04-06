import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class UploadApiService {
  final Dio dio;

  UploadApiService(this.dio);

  // Upload profile picture
  Future<Response> uploadProfilePicture(File imageFile) async {
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

      // Send POST request to upload the file
      Response response = await dio.post(
        '/user/edit/profile-picture',
        data: formData,
      );

      return response;
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
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
