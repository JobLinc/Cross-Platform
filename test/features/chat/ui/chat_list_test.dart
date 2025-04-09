// import 'package:bloc/src/bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:joblinc/core/widgets/custom_search_bar.dart';
// import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
// import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
// import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
// import 'package:joblinc/features/jobs/data/models/job_model.dart';
// import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';
// import 'package:mocktail/mocktail.dart';

// class MockChatListCubit extends MockCubit<ChatListState> implements ChatListCubit {}

// class FakeChatListState extends Fake implements ChatListState {}

// void main() {
//   late MockChatListCubit mockChatListCubit;

//   setUpAll(() {
//     registerFallbackValue(FakeChatListState());
//   });

//   setUp(() {
//     mockChatListCubit = MockChatListCubit();

//     // Return a default state
//     when(() => mockChatListCubit.state).thenReturn(ChatListInitial());

//     // Return an empty stream or emit states if needed
//     whenListen(
//       MockChatListCubit as BlocBase<ChatListState>,
//       Stream<ChatListState>.fromIterable([ChatListInitial()]),
//     );
//   });

// Future<void> pumpChatListScreen(WidgetTester tester) async {
//     await tester.pumpWidget(
//       ScreenUtilInit(
//         designSize: Size(412, 924),
//         minTextAdapt: true,
//         builder: (context, child) {
//           return MaterialApp(
//             routes: {
//               '/homeScreen': (context) =>
//                   const Scaffold(body: Text('Home Screen')),
//               '/signUpScreen': (context) =>
//                   const Scaffold(body: Text('Sign Up Screen')),
//               '/forgotPasswordScreen': (context) => const Scaffold(
//                   body: Text('Forgot Password', key: Key("forget_text"))),
//             },
//             home: BlocProvider<ChatListCubit>.value(
//               value: mockChatListCubit,
//               child: ChatListScreen(),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   group('ChatListScreen Widget Tests', () {
//     testWidgets('displays loading overlay when state is ChatListLoading',
//         (WidgetTester tester) async {
//       // Arrange
//       when(() => mockChatListCubit.state).thenReturn(ChatListLoading());
//       whenListen(
//           MockChatListCubit as BlocBase<ChatListState>, Stream<ChatListState>.fromIterable([ChatListLoading()]));

//       // Act
//       await pumpChatListScreen(tester);

//       // Assert
//       expect(find.byType(LoadingIndicatorOverlay), findsOneWidget);
//     });

//     testWidgets('shows SnackBar and navigates on ChatListSuccess',
//         (WidgetTester tester) async {
//       // Arrange
//       when(() => mockChatListCubit.state).thenReturn(ChatListInitial());
//       whenListen(
//         MockChatListCubit as BlocBase<ChatListState>,
//         Stream<ChatListState>.fromIterable([ChatListLoading(), ChatListLoaded()]),
//       );

//       await pumpChatListScreen(tester);

//       // Act
//       await tester.pump(); // Processes state changes
//       await tester
//           .pump(const Duration(milliseconds: 500)); // Animates the SnackBar

//       // Assert
//       expect(find.text('ChatList success'), findsOneWidget);
//     });

//     testWidgets('shows error SnackBar on ChatListFailure',
//         (WidgetTester tester) async {
//       const errorMessage = 'Invalid credentials';
//       // Arrange
//       when(() => mockChatListCubit.state).thenReturn(ChatListInitial());
//       whenListen(
//         MockChatListCubit as BlocBase<ChatListState>,
//         Stream<ChatListState>.fromIterable(
//             [ChatListLoading(), ChatListErrorLoading(errorMessage)]),
//       );

//       await pumpChatListScreen(tester);

//       // Act
//       await tester.pump(); // Processes state changes
//       await tester
//           .pump(const Duration(milliseconds: 500)); // Animates the SnackBar

//       // Assert
//       expect(find.textContaining(errorMessage), findsOneWidget);
//     });
//     testWidgets('calls ChatList() on button tap when form is valid',
//         (tester) async {
//       // Arrange
//       when(() => mockChatListCubit.state).thenReturn(ChatListInitial());
//       when(() => mockChatListCubit.getAllChats()).thenAnswer((_) async {});
//       whenListen(
//         MockChatListCubit as BlocBase<ChatListState>,
//         Stream<ChatListState>.fromIterable([ChatListInitial()]),
//       );

//       await pumpChatListScreen(tester);

//       // Act
//       await tester.pumpAndSettle(); // Wait for the UI to settle

//       // Act
//       // final emailField = find.byKey(const Key('login_email_textfield'));
//       // final passwordField = find.byKey(const Key('login_password_textfield'));
//       // final loginButton = find.byKey(const Key('login_continue_button'));

//       // await tester.enterText(emailField, 'test@example.com');
//       // await tester.enterText(passwordField, 'password123');

//       // await tester.pump();
//       // tester.ensureVisible(loginButton);
//       // await tester.tap(loginButton);
//       // await tester.pump();

//       // Assert
//       verify(() => mockChatListCubit.getAllChats())
//           .called(1);
//     });

//     testWidgets('navigates to SignUp screen on Join JobLinc tap',
//         (WidgetTester tester) async {
//       // Arrange
//       when(() => mockChatListCubit.state).thenReturn(ChatListInitial());

//       await pumpChatListScreen(tester);

//       // Act
//       await tester.pumpAndSettle(); // Wait for the UI to settle

//       // Find the "Join JobLinc" TextSpan inside the RichText
//       final gestureRecognizerFinder =
//           find.byKey(const Key('joinJobLinc')).first;
//       expect(gestureRecognizerFinder, findsOneWidget);

//       // Tap the "Join JobLinc"
//       await tester.tap(gestureRecognizerFinder);
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('Sign Up Screen'), findsOneWidget);
//     });

//     testWidgets('navigates to ForgotPassword screen on tap',
//         (WidgetTester tester) async {
//       // Arrange
//       when(() => mockChatListCubit.state).thenReturn(ChatListInitial());

//       await pumpChatListScreen(tester);

//       // Act
//       await tester.pumpAndSettle(); // Wait for the UI to settle

//       // Tap "Forgot Password?"
//       final forgotPasswordText =
//           find.byKey(const Key('login_forgotpassword_text')).first;
//       expect(forgotPasswordText, findsOneWidget);
//       await tester.ensureVisible(forgotPasswordText);
//       await tester.tap(forgotPasswordText);
//       //await tester.tap(find.text('Forgot Password?'));
//       await tester.pumpAndSettle();

//       // Debug print to check if the screen is rendered

//       // Assert
//       expect(find.text("Forgot Password"), findsOneWidget);
//     });
//   });
// }



import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:mockito/mockito.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';

//import '../../logic/cubit/chat_list_cubit_test.mocks.dart';
import '../logic/chat_list_cubit_test.dart';

void main() {
  late MockChatRepo mockChatRepo;
  late ChatListCubit chatListCubit;

  setUp(() {
    mockChatRepo = MockChatRepo();
    chatListCubit = ChatListCubit(mockChatRepo);
  });

  tearDown(() {
    chatListCubit.close();
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<ChatListCubit>(
        create: (_) => chatListCubit,
        child: child,
      ),
    );
  }

  testWidgets('Shows loading indicator when ChatListLoading state is emitted', (WidgetTester tester) async {
    when(mockChatRepo.getAllChats()).thenAnswer((_) async => []);
    chatListCubit.emit(ChatListLoading());

    await tester.pumpWidget(createTestWidget(ChatListScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shows empty message when ChatListEmpty state is emitted', (WidgetTester tester) async {
    chatListCubit.emit(ChatListEmpty());

    await tester.pumpWidget(createTestWidget(ChatListScreen()));

    expect(find.text("Create Chats with people to see them here"), findsOneWidget);
  });

  testWidgets('Displays chat list when ChatListLoaded state is emitted', (WidgetTester tester) async {
    // final mockChats = [
    //   Chat(
    //     id: "1",
    //     userID: "user1",
    //     userName: "Alice",
    //     userAvatar: null,
    //     lastMessage: LastMessage(
    //       senderID: "user1",
    //       text: "Hello!",
    //       timestamp: DateTime.now(),
    //       messageType: "text",
    //     ),
    //     lastUpdate: DateTime.now(),
    //     unreadCount: 2,
    //     lastSender: "Alice",
    //     isOnline: true,
    //   ),
    // ];

    chatListCubit.emit(ChatListLoaded(chats: mockChats));

    await tester.pumpWidget(createTestWidget(ChatListScreen()));

    expect(find.text("Alice"), findsOneWidget);
    expect(find.text("Hello!"), findsOneWidget);
  });

  testWidgets('Displays error message when ChatListErrorLoading state is emitted', (WidgetTester tester) async {
    chatListCubit.emit(ChatListErrorLoading("Failed to load chats"));

    await tester.pumpWidget(createTestWidget(ChatListScreen()));

    expect(find.text("Something went wrong."), findsOneWidget);
  });
}

