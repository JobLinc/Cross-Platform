import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

bool apiEndPointFunctional = true;

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio) {
    // Print statement removed
  }

  Future<Response> getChatById(String chatId) async {
    if (apiEndPointFunctional) {
      try {
        final response = await _dio.get('/chat/chat-card/$chatId');
        return response;
      } catch (e) {
        throw Exception("Failed to fetch chat details: $e");
      }
    } else {
      await Future.delayed(Duration(seconds: 1));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [], //mockChats.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  Future<Response> getTotalUnreadCount() async {
    try {
      final response = await _dio.get('/chat/unread-count');
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data["message"].toString().split(":").last);
      }
      throw Exception("Exception without response: ${e.message}");
    }
  }

  Future<Response> getAllChats() async {
    if (apiEndPointFunctional) {
      try {
        final response = await _dio.get('/chat/all');
        return response;
      } catch (e) {
        throw Exception("Failed to fetch chats: $e");
      }
    } else {
      await Future.delayed(Duration(seconds: 1));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [], //mockChats.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  Future<Response> getChatDetails(String chatId) async {
    try {
      final response = await _dio.get('/chat/c/$chatId');
      return response;
    } catch (e) {
      throw Exception("Failed to fetch chat details: $e");
    }
  }

  /// Create a new chat (private or group)
  Future<Response> createChat({
    required List<String> receiverIds,
    String? title,
  }) async {
    try {
      final data = {
        "receiverIds": receiverIds,
        if (title != null) "title": title,
      };
      final response = await _dio.post('/chat/create', data: data);
      return response;
    } catch (e) {
      throw Exception("Failed to create chat: $e");
    }
  }

  /// Open a chat with specified participants
  Future<Response> openChat({
    required List<String> receiverIDs,
    required String senderID,
  }) async {
    if (apiEndPointFunctional) {
      try {
        final response = await _dio.post('/chat/openChat', data: {
          "receiverIDs": receiverIDs,
          "senderID": senderID,
        });
        return response;
      } catch (e) {
        throw Exception("Failed to open chat: $e");
      }
    } else {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [], //mockChats.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  /// Delete a chat by ID
  Future<void> deleteChat(String chatId) async {
    try {
      await _dio.delete('/chat/delete', data: {"chatId": chatId});
    } catch (e) {
      throw Exception("Failed to delete chat: $e");
    }
  }

  Future<void> archiveChat(String chatId) async {
    try {
      await _dio.put('/chat/archive', data: {"chatId": chatId});
    } catch (e) {
      throw Exception("Failed to delete chat: $e");
    }
  }

  /// Change the chat title
  Future<void> changeTitle(
      {required String chatId, required String chatTitle}) async {
    try {
      await _dio.put('/chat/changeTitle', data: {
        "chatId": chatId,
        "chatTitle": chatTitle,
      });
    } catch (e) {
      throw Exception("Failed to change chat title: $e");
    }
  }

  /// Mark a chat as read/unread for a user
  Future<void> markReadOrUnread({required String chatId}) async {
    try {
      final response = await _dio.put('/chat/readOrUnread', data: {
        "chatId": chatId,
      });
    } catch (e) {
      throw Exception("Failed to mark chat: $e");
    }
  }

  Future<Response> getConnections() async {
    try {
      final response = await _dio.get('/connection/connected');
      if (response.statusCode != 200) {
        throw Exception("Failed to fetch connections");
      }
      return response;
    } catch (e, stack) {
      throw Exception("Failed to fetch connections for the user: $e");
    }
  }

  Future<String> uploadMedia(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: getMediaType(file),
        ),
      });
      final response = await _dio.post('/chat/upload-media', data: formData);
      return (response.data as String);
    } catch (e) {
      throw Exception("Failed to upload media: $e");
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
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
      case 'docx':
        return MediaType(
            'application', 'msword'); // MIME type for Word documents
      default:
        return MediaType(
            'application', 'octet-stream'); // Fallback for unsupported types
    }
  }
}
