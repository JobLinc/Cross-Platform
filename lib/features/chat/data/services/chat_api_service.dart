import 'package:dio/dio.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';

bool apiEndPointFunctional=false;

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio);

  Future<Response> getAllChats() async {
    if(0==1){
      try {
        final response = await _dio.get('/chat/all',);
        return response;
      } catch (e) {
        throw Exception("Failed to fetch chats: $e");
      }
    } else {
      await Future.delayed(Duration(seconds: 1));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: mockChats.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      //print(response);
      return response;
    }
  }


Future<Response> getChatById(String chatId) async {
    if(0==1){
      try {
        final response = await _dio.get('/chat/c/$chatId');
        return response;
      } catch (e) {
        throw Exception("Failed to fetch chat details: $e");
      }
    } else {
      await Future.delayed(Duration(seconds: 1));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: mockChats.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }
  

  /// Create a new chat group
  Future<void> createChat() async {
    if(0==1){
      try {
        await _dio.post('/chat/create');
      } catch (e) {
        throw Exception("Failed to create chat: $e");
      }
    } else{

    }
  }

  /// Open a chat with specified participants
  Future<Response> openChat({required List<String> receiverIDs,required String senderID,}) async {
    if(0==1){
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
          data: mockChats.map((job) => job.toJson()).toList(),
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

  /// Change the chat title
  Future<void> changeChatTitle({required String chatId,required String chatTitle}) async {
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
  Future<void> markChatAsRead({required String chatId, required String userId}) async {
    try {
      await _dio.put('/chat/mark', data: {
        "chatId": chatId,
        "userId": userId,
      });
    } catch (e) {
      throw Exception("Failed to mark chat: $e");
    }
  }
}

//   Future<List<dynamic>> getAllChats() async {
//   try {
//     if (apiEndPointFunctional) {
//       final response = await _dio.get('/chat/get');
//       return response.data;
//     } else {
//       return mockChats.map((chat) => chat.toJson()).toList();
//     }
//   } on DioException catch (e) {
//     throw Exception(_handleDioError(e));
//   }
// }


  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        return 'Incorrect credentials';
      } else {
        return 'internal Server error}';
      }
    } else {
      return 'Network error: ${e.message}';
    }
  }
