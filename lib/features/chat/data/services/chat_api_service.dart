import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

bool apiEndPointFunctional = true;

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio) {
    print('[ChatApiService] Dio baseUrl: ${_dio.options.baseUrl}');
  }

  Future<Response> getAllChats() async {
    if (apiEndPointFunctional) {
      try {
        final response = await _dio.get('/chat/all');
        print("all chat response ${response}" );
        return response;
      } catch (e) {
        throw Exception("Failed to fetch chats: $e");
      }
    } else {
      await Future.delayed(Duration(seconds: 1));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [],//mockChats.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      //print(response);
      return response;
    }
  }

  Future<Response> getChatDetails(String chatId) async {
    //if (apiEndPointFunctional) {
    try {
      final response = await _dio.get('/chat/c/$chatId');
      print("1 $response");
      return response;
    } catch (e) {
      throw Exception("Failed to fetch chat details: $e");
    }
    //  } else {
    //     ChatDetail mockChatDetail = mockChatDetails
    //         .firstWhere((chatDetail) => chatDetail.chatId == chatId);
    //     final response = Response<dynamic>(
    //       requestOptions: RequestOptions(path: ''),
    //       data: mockChatDetail.toJson(),
    //       statusCode: 200,
    //       statusMessage: 'OK',
    //     );
    //     return response;
    //   }
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
          data: [],//mockChats.map((job) => job.toJson()).toList(),
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
      await _dio.put('/chat/readOrUnread', data: {
        "chatId": chatId,
      });
    } catch (e) {
      throw Exception("Failed to mark chat: $e");
    }
  }

  Future<Response> getConnections() async {
    print('[ChatApiService] Calling /connection/connected...');
    try {
      final response = await _dio.get('/connection/connected');
      print('[ChatApiService] Response: $response');
      if (response.statusCode != 200) {
        print('[ChatApiService] Non-200 status code: ${response.statusCode}');
        throw Exception("Failed to fetch connections");
      }
      // Debug: print response data
      print('[ChatApiService] Response data: ${response.data}');
      return response;
    } catch (e, stack) {
      print('[ChatApiService] Error fetching connections: $e\n$stack');
      throw Exception("Failed to fetch connections for the user: $e");
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

// List<ChatDetail> mockChatDetails = [
//   ChatDetail(
//     chatId: "chat_001",
//     chatName: "اخويا الجيار في اللة",
//     chatPicture:
//         ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQybOhACvhkP99hH4-8UVZyRs429BfgjPBiNA&s",],
//     participants: [
//       Participant(
//         userId: "user_001",
//         firstName: "Abdelrahman",
//         lastName: "Sameh",
//         profilePicture: "https://example.com/john.jpg",
//       ),
//       Participant(
//         userId: "user_002",
//         firstName: "Jane",
//         lastName: "Doe",
//         profilePicture: "https://example.com/jane.jpg",
//       ),
//     ],
//     messages: [
//       Message(
//         messageId: "msg_001",
//         content: MessageContent(
//           text: "ezayak ya 3m tamer",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_001",
//         status: "delivered",
//       ),
//       Message(
//         messageId: "msg_002",
//         content: MessageContent(
//           text:  "انزل يا متدلع",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_002",
//         status: "read",
//       ),
//     ],
//   ),
//   ChatDetail(
//     chatId: "chat_002",
//     chatName: "عم احمد",
//     chatPicture:
//         ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFhJVW-WJ9ShTQP5iQtnp_jqxbI5VB_Fm3NHgirqN_GXZ2wNDwxgq_s0E6MmL5uwhUj0o&usqp=CAU",],
//     participants: [
//       Participant(
//         userId: "user_001",
//         firstName: "Abdelrahman",
//         lastName: "Sameh",
//         profilePicture: "https://example.com/alice.jpg",
//       ),
//       Participant(
//         userId: "user_004",
//         firstName: "Bob",
//         lastName: "Johnson",
//         profilePicture: "https://example.com/bob.jpg",
//       ),
//     ],
//     messages: [
//       Message(
//         messageId: "msg_003",
//         content: MessageContent(
//           text: "....",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_003",
//         status: "delivered",
//       ),
//       Message(
//         messageId: "msg_004",
//         content: MessageContent(
//           text: " انت منين ؟",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_001",
//         status: "read",
//       ),
//     ],
//   ),
//   ChatDetail(
//     chatId: "chat_003",
//     chatName: "ٍSakr ",
//     chatPicture:
//                 ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFinmoBS3C0r1jV9YOTvO6HFLcrDYYffSN-i7LJs6fAsJ24SV3-lpLKvTpp1WnCJWbUP4&usqp=CAU",],
//     participants: [
//       Participant(
//         userId: "user_001",
//         firstName: "Abdelrahman",
//         lastName: "Sameh",
//         profilePicture: "https://example.com/alice.jpg",
//       ),
//       Participant(
//         userId: "user_004",
//         firstName: "Sakr",
//         lastName: " ",
//         profilePicture: "https://example.com/bob.jpg",
//       ),
//     ],
//     messages: [
//       Message(
//         messageId: "msg_003",
//         content: MessageContent(
//           text: "Ana 2afelt el control w ha2afel ba2y el mawad",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_004",
//         status: "delivered",
//       ),
//       Message(
//         messageId: "msg_004",
//         content: MessageContent(
//           text: "Ana awel el dof3a",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_004",
//         status: "read",
//       ),
//     ],
//   ),
//   ChatDetail(
//     chatId: "chat_004",
//     chatName: "Ahmed Hesham",
//     chatPicture:
//         ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsyI44s5kurKNs7i-ZSj0JlEGcBlCdAYGegg&s",],
//     participants: [
//       Participant(
//         userId: "user_001",
//         firstName: "Abdelrahman",
//         lastName: "Sameh",
//         profilePicture: "https://example.com/alice.jpg",
//       ),
//       Participant(
//         userId: "user_004",
//         firstName: "Ahmed",
//         lastName: "Hesham",
//         profilePicture: "https://example.com/bob.jpg",
//       ),
//     ],
//     messages: [
//       Message(
//         messageId: "msg_003",
//         content: MessageContent(
//           text: "The project deadline is tomorrow.",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_005",
//         status: "delivered",
//       ),
//       Message(
//         messageId: "msg_004",
//         content: MessageContent(
//           text: " اخلص يبني الديدلاين قرب",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_005",
//         status: "read",
//       ),
//     ],
//   ),
//   ChatDetail(
//     chatId: "chat_005",
//     chatName: "Margot Robbie",
//     chatPicture:
//         ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReFc97WTW0sr9jvt-3n9_01sJdimMpIL9lxpNJytt6kIeSbRHEjNxBQrZ8yHipEMdxyyw&usqp=CAU",],    participants: [
//       Participant(
//         userId: "user_001",
//         firstName: "Abdelrahman",
//         lastName: "Sameh",
//         profilePicture: "https://example.com/alice.jpg",
//       ),
//       Participant(
//         userId: "user_004",
//         firstName: "Bob",
//         lastName: "Johnson",
//         profilePicture: "https://example.com/bob.jpg",
//       ),
//     ],
//     messages: [
//       Message(
//         messageId: "msg_003",
//         content: MessageContent(
//           text: "don't leave me pls ",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_006",
//         status: "delivered",
//       ),
//       Message(
//         messageId: "msg_003",
//         content: MessageContent(
//           text: "I cant live without you",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_006",
//         status: "delivered",
//       ),
//       Message(
//         messageId: "msg_004",
//         content: MessageContent(
//           text: "انا داخل انام",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_001",
//         status: "read",
//       ),
//       Message(
//         messageId: "msg_004",
//         content: MessageContent(
//           text: "Night darling ❤️❤️",
//           image: "",
//           video: "",
//           audio: "",
//           document: "",
//         ),
//         sentDate: DateTime.now().subtract(Duration(hours: 2)),
//         senderId: "user_006",
//         status: "read",
//       ),

//     ],
//   ),
// ];
