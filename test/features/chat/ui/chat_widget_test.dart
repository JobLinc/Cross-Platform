import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

// Mock classes
class MockChatListCubit extends MockCubit<ChatListState>
    implements ChatListCubit {
  @override
  List<Chat> get chats => [];

  @override
  Future<void> getAllChats() async {}

  @override
  Future<void> reloadChats() async {}

  @override
  void toggleSelection(String chatId) {}

  @override
  void clearSelection() {}

  @override
  void setTyping(String chatId, bool isTyping) {}

  @override
  void updateChatCard(Map<String, dynamic> data) {}

  @override
  void filteredChats(bool filter) {}

  @override
  void searchChats(String query) {}

}

class MockAuthService extends Mock implements AuthService {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockChatSocketService extends ChatSocketService {
  static final instance = MockChatSocketService._();
  MockChatSocketService._() : super();

  @override
  Future<bool> initialize(
      {required String userId, required String accessToken}) async {
    return false; // Don't establish real connection in tests
  }

  @override
  void clearEventHandlers() {}
}

class _NoHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? _) =>
      super.createHttpClient(_)..badCertificateCallback = (_, __, ___) => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testChat = Chat(
    chatId: 'c1',
    chatName: 'Alice',
    chatPicture: [],
    lastMessage: 'Hello',
    senderName: "Bob",
    sentDate: DateTime.now(),
    unreadCount: 1,
    isRead: false,
  );

  late MockChatListCubit mockCubit;
  late MockNavigatorObserver mockObserver;
  late MockAuthService mockAuthService;

  setUpAll(() {
    HttpOverrides.global = _NoHttpOverrides();
    registerFallbackValue(MaterialPageRoute<void>(builder: (_) => Container()));

    // Replace real socket service with mock
    ChatSocketService.originalInstance = ChatSocketService.instance;
    ChatSocketService.instance = MockChatSocketService.instance;
  });

  tearDownAll(() {
    // Restore original socket service if it was saved
    if (ChatSocketService.originalInstance != null) {
      ChatSocketService.instance = ChatSocketService.originalInstance!;
    }
  });

  setUp(() {
    mockCubit = MockChatListCubit();
    mockObserver = MockNavigatorObserver();
    mockAuthService = MockAuthService();

    // Configure GetIt
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AuthService>()) {
      getIt.unregister<AuthService>();
    }
    getIt.registerSingleton<AuthService>(mockAuthService);

    // Mock auth service methods
    when(() => mockAuthService.getUserId())
        .thenAnswer((_) => Future.value('test-user-id'));
    when(() => mockAuthService.getAccessToken())
        .thenAnswer((_) => Future.value('test-access-token'));

    // Configure cubit default behavior
    when(() => mockCubit.state).thenReturn(ChatListLoaded(chats: [testChat]));
  });

  tearDown(() {
    // Clean up socket service
    ChatSocketService.instance.clearEventHandlers();
  });

  // Utility to pump the widget under test
  Future<void> pumpChatListScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          routes: {
            Routes.chatScreen: (_) => Scaffold(
                  appBar: AppBar(title: Text('Chat Detail')),
                  body: Center(child: Text('Chat Detail Screen')),
                ),
          },
          home: BlocProvider<ChatListCubit>.value(
            value: mockCubit,
            child: const ChatListScreen(),
          ),
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    // Allow all pending timers to complete
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('ChatListScreen', () {
    testWidgets('displays loading state correctly', (tester) async {
      // Given a loading state
      when(() => mockCubit.state).thenReturn(ChatListLoading());

      // When the screen is rendered
      await pumpChatListScreen(tester);

      // Then a loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state correctly', (tester) async {
      // Given an empty state
      when(() => mockCubit.state).thenReturn(ChatListEmpty());

      // When the screen is rendered
      await pumpChatListScreen(tester);

      // Then the empty state message is shown
      expect(find.text('No conversations yet'), findsOneWidget);
    });

    testWidgets('displays conversations correctly', (tester) async {
      // Given a loaded state with conversations
      when(() => mockCubit.state).thenReturn(ChatListLoaded(chats: [testChat]));

      // When the screen is rendered
      await pumpChatListScreen(tester);

      // Then the chat information is shown
      expect(find.text('Alice'), findsOneWidget);
      expect(find.textContaining('Bob'), findsOneWidget);
    });

    testWidgets('handles selection mode correctly', (tester) async {
      // Given chat data is loaded
      when(() => mockCubit.state).thenReturn(ChatListLoaded(chats: [testChat]));
      when(() => mockCubit.toggleSelection(any())).thenReturn(null);

      // When the screen is rendered
      await pumpChatListScreen(tester);

      // And a long press is performed on a chat
      final textFinder = find.text('Alice');
      expect(textFinder, findsOneWidget);
      await tester.longPress(textFinder);
      await tester.pumpAndSettle();

      // Then selection is toggled
      verify(() => mockCubit.toggleSelection(any())).called(1);
    });
  });
}

// Add extension method to ChatSocketService to allow test swapping
extension ChatSocketServiceTesting on ChatSocketService {
  static ChatSocketService? originalInstance;
}
