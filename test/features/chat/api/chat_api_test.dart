import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

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
  });

  test('getAllChats returns mock data when apiEndPointFunctional=false', () async {
    apiEndPointFunctional = false;
    final resp = await api.getAllChats();
    expect(resp.statusCode, 200);
    final data = resp.data as List;
    expect(data, isNotEmpty);
    // parse first item
    final chat = Chat.fromJson(data.first as Map<String, dynamic>);
    expect(chat.chatId, isNotEmpty);
  });

  test('getChatDetails throws when Dio throws', () {
    when(() => mockDio.get('/chat/c/xyz'))
      .thenThrow(Exception('error'));
    expect(api.getChatDetails('xyz'), throwsException);
  });

  test('openChat returns mock list when apiEndPointFunctional=false', () async {
    apiEndPointFunctional = false;
    final resp = await api.openChat(receiverIDs: ['u1'], senderID: 'u2');
    expect(resp.statusCode, 200);
    final data = resp.data as List;
    expect(data, isA<List>());
  });

  test('createChat does not throw when functional=false', () async {
    apiEndPointFunctional = false;
    await api.createChat();
  });
}
