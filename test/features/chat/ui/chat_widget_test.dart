import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:mocktail/mocktail.dart';

/// 1) A MockCubit for ChatListState
class MockChatListCubit extends MockCubit<ChatListState>
    implements ChatListCubit {
  List<Chat> chats = [];
}
class FakeChatListState extends Fake implements ChatListState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _NoHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? _) =>
      super.createHttpClient(_)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
}
void main() {
  late MockChatListCubit mockCubit;
  late MockNavigatorObserver mockObserver;

  final testChat = Chat(
    chatId: 'c1',
    chatName: 'Alice',
    chatPicture: [],
    lastMessage: 'Hello',
    sentDate: DateTime.now(),
    unreadCount: 1,
    isRead: false,
  );

  setUpAll(() {
    // required by mockito for any unstubbed ChatListState
    HttpOverrides.global = _NoHttpOverrides();
    registerFallbackValue(FakeChatListState());
  });

  setUp(() {
    mockCubit = MockChatListCubit();
    mockObserver = MockNavigatorObserver();

    // stub the initial fetch
    when(() => mockCubit.getAllChats()) // or getAllChats, rename if needed
        .thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockCubit.close();
  });

  /// Helper to pump the ChatListScreen under test
  Future<void> pumpChatList(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          home: BlocProvider<ChatListCubit>.value(
            value: mockCubit,
            child: const ChatListScreen(),
          ),
          navigatorObservers: [mockObserver],
        ),
      ),
    );
  }

  group('ChatListScreen widget tests', () {
    testWidgets('shows loading indicator on ChatListInitial',
        (tester) async {
      when(() => mockCubit.state).thenReturn(ChatListLoading());
      whenListen<ChatListState>(
        mockCubit,
        Stream.value(ChatListLoading()),
        initialState: ChatListLoading(),
      );

      await pumpChatList(tester);
      await tester.pump(); // rebuild

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error on ChatListErrorLoading',
        (tester) async {
      const err = 'oops';
      when(() => mockCubit.state)
          .thenReturn( ChatListErrorLoading(err));
      whenListen<ChatListState>(
        mockCubit,
        Stream.value( ChatListErrorLoading(err)),
        initialState: ChatListErrorLoading(err),
      );

      await pumpChatList(tester);
      await tester.pump();

      expect(find.textContaining('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows chat list on ChatListLoaded',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(ChatListLoaded(chats: [testChat]));
      whenListen<ChatListState>(
        mockCubit,
        Stream.value(ChatListLoaded(chats: [testChat])),
        initialState: ChatListLoaded(chats: [testChat]),
      );

      await pumpChatList(tester);
      await tester.pump();
      await tester.pumpAndSettle();

      // Expect the ChatCard for 'Alice'
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
      expect(find.byKey(const Key('chatList_openChat_cardc1')),
          findsOneWidget);
    });

    testWidgets('navigates to ChatScreen when tapping a chat',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(ChatListLoaded(chats: [testChat]));
      whenListen<ChatListState>(
        mockCubit,
        Stream.value(ChatListLoaded(chats: [testChat])),
        initialState: ChatListLoaded(chats: [testChat]),
      );

      await pumpChatList(tester);
      await tester.pumpAndSettle();

      // Tap the Alice card
      await tester.tap(
          find.byKey(const Key('chatList_openChat_cardc1')));
      await tester.pumpAndSettle();

      // Verify push
      //verify(mockObserver.didPush(captureAny, any)).called(1);

      // ChatScreen should appear with title 'Alice'
      expect(find.byType(ChatScreen), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Alice'), findsOneWidget);
    });
  });
}
