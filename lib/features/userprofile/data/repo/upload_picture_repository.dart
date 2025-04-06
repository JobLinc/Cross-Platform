import 'dart:io';
import 'package:dio/dio.dart';
import 'package:joblinc/features/userprofile/data/service/upload_user_picture.dart';

class UploadRepository {
  final UploadApiService uploadApiService;
  UploadRepository({required this.uploadApiService});

  // Call the API service to upload the profile picture
  Future<Response> uploadProfilePicture(File imageFile) async {
    try {
      return await uploadApiService.uploadProfilePicture(imageFile);
    } catch (e) {
      rethrow;
    }
  }

  toMap() {}
}
