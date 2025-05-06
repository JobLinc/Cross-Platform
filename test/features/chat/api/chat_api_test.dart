import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

// For testing the sendMessage functionality since it's not in the main class
extension ChatServiceExtension on ChatApiService {
  Future<Response> sendMessage({
    required Dio dio,
    required String chatId,
    required String senderId,
    required String content,
    required String messageType,
  }) async {
    return dio.post(
      '/chat/message/send',
      data: {
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
        'messageType': messageType,
      },
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ChatApiService api;
  late MockDio mockDio;

  setUpAll(() async {
    await setupGetIt();
  });

  setUp(() {
    mockDio = MockDio();
    api = ChatApiService(mockDio);

    // Always assume apiEndPointFunctional = true in all tests
    apiEndPointFunctional = true;
  });

  group('getAllChats tests', () {
    test('getAllChats returns data correctly', () async {
      when(() => mockDio.get('/chat/all')).thenAnswer((_) async => Response(
            data: [
              {
                'chatId': 'testId',
                'chatName': 'Test Chat',
                'chatPicture': ['https://example.com/image.jpg'],
                'lastMessage': 'Hello world',
                'senderName': 'Test User',
                'sentDate': DateTime.now().toIso8601String(),
                'unreadCount': 1,
                'isRead': false
              }
            ],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final response = await api.getAllChats();
      expect(response.statusCode, 200);
      expect(response.data, isNotEmpty);
      verify(() => mockDio.get('/chat/all')).called(1);
    });

    test('getAllChats handles error response correctly', () {
      when(() => mockDio.get('/chat/all')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/chat/all'),
          error: 'Network error',
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => api.getAllChats(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getChatDetails tests', () {
    test('getChatDetails returns chat data correctly', () async {
      const chatId = 'test-chat-id';
      when(() => mockDio.get('/chat/c/$chatId'))
          .thenAnswer((_) async => Response(
                data: {
                  'chatId': chatId,
                  'chatName': 'Test Chat Details',
                  'chatPicture': ['https://example.com/image.jpg'],
                  'lastMessage': 'Hello from details',
                  'senderName': 'Detail Sender',
                  'sentDate': DateTime.now().toIso8601String(),
                  'unreadCount': 0,
                  'isRead': true,
                  'messages': []
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final response = await api.getChatDetails(chatId);
      expect(response.statusCode, 200);
      expect(response.data['chatId'], chatId);
      verify(() => mockDio.get('/chat/c/$chatId')).called(1);
    });

    test('getChatDetails throws when Dio throws', () {
      const chatId = 'xyz';
      when(() => mockDio.get('/chat/c/$chatId')).thenThrow(Exception('error'));
      expect(() => api.getChatDetails(chatId), throwsException);
    });
  });

  group('openChat tests', () {
    test('openChat makes correct API call with parameters', () async {
      final receiverIDs = ['u1', 'u3'];
      const senderID = 'u2';

      when(() => mockDio.post(
            '/chat/openChat',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: [
              {'message': 'Chat opened successfully'}
            ],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final response =
          await api.openChat(receiverIDs: receiverIDs, senderID: senderID);
      expect(response.statusCode, 200);
      expect(response.data, isNotEmpty);

      verify(() => mockDio.post(
            '/chat/openChat',
            data: {'receiverIDs': receiverIDs, 'senderID': senderID},
          )).called(1);
    });
  });

  group('createChat tests', () {
    test('createChat makes correct API call', () async {
      final receiverIds = ['u1', 'u2'];
      const title = 'Test Chat';

      when(() => mockDio.post('/chat/create', data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'chatId': 'new-chat-id',
                  'chatName': title,
                  'participants': receiverIds,
                  'createdAt': DateTime.now().toIso8601String()
                },
                statusCode: 201,
                requestOptions: RequestOptions(path: ''),
              ));

      final response =
          await api.createChat(receiverIds: receiverIds, title: title);
      expect(response.statusCode, 201);
      expect(response.data['chatId'], 'new-chat-id');

      verify(() => mockDio.post('/chat/create',
          data: {'receiverIds': receiverIds, 'title': title})).called(1);
    });
  });

  group('sendMessage tests', () {
    test('sendMessage makes correct API call with message data', () async {
      const chatId = 'chat1';
      const senderId = 'user1';
      const content = 'Hello';
      const messageType = 'text';

      when(() => mockDio.post(
            '/chat/message/send',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {
              'messageId': 'msg123',
              'status': 'sent',
              'timestamp': DateTime.now().toIso8601String(),
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resp = await api.sendMessage(
        chatId: chatId,
        senderId: senderId,
        content: content,
        messageType: messageType, dio: mockDio,
      );

      expect(resp.statusCode, 200);
      expect(resp.data['messageId'], 'msg123');

      verify(() => mockDio.post(
            '/chat/message/send',
            data: {
              'chatId': chatId,
              'senderId': senderId,
              'content': content,
              'messageType': messageType,
            },
          )).called(1);
    });

    test('sendMessage handles error properly', () {
      const chatId = 'chat1';
      const senderId = 'user1';
      const content = 'Hello';
      const messageType = 'text';

      when(() => mockDio.post(
            '/chat/message/send',
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/chat/message/send'),
        error: 'Failed to send message',
      ));

      expect(
          () => api.sendMessage(
                chatId: chatId,
                senderId: senderId,
                content: content,
                messageType: messageType,
                dio: mockDio,
              ),
          throwsA(isA<DioException>()));
    });
  });
}
