import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/helpers/loading_overlay.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/login/ui/screens/login_screen.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/login/logic/cubit/login_state.dart';

// ------------------
// Mock & Fake Classes
// ------------------

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class FakeLoginState extends Fake implements LoginState {}

void main() {
  late MockLoginCubit mockLoginCubit;

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
  });

  setUp(() {
    mockLoginCubit = MockLoginCubit();

    // Return a default state
    when(() => mockLoginCubit.state).thenReturn(LoginInitial());

    // Return an empty stream or emit states if needed
    whenListen(
      mockLoginCubit,
      Stream<LoginState>.fromIterable([LoginInitial()]),
    );
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            routes: {
              '/homeScreen': (context) =>
                  const Scaffold(body: Text('Home Screen')),
              '/signUpScreen': (context) =>
                  const Scaffold(body: Text('Sign Up Screen')),
              '/forgotPasswordScreen': (context) => const Scaffold(
                  body: Text('Forgot Password', key: Key("forget_text"))),
            },
            home: BlocProvider<LoginCubit>.value(
              value: mockLoginCubit,
              child: LoginScreen(),
            ),
          );
        },
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('displays loading overlay when state is LoginLoading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginLoading());
      whenListen(
          mockLoginCubit, Stream<LoginState>.fromIterable([LoginLoading()]));

      // Act
      await pumpLoginScreen(tester);

      // Assert
      expect(find.byType(LoadingIndicatorOverlay), findsOneWidget);
    });

    testWidgets('shows SnackBar and navigates on LoginSuccess',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());
      whenListen(
        mockLoginCubit,
        Stream<LoginState>.fromIterable([LoginLoading(), LoginSuccess()]),
      );

      await pumpLoginScreen(tester);

      // Act
      await tester.pump(); // Processes state changes
      await tester
          .pump(const Duration(milliseconds: 500)); // Animates the SnackBar

      // Assert
      expect(find.text('login success'), findsOneWidget);
    });

    testWidgets('shows error SnackBar on LoginFailure',
        (WidgetTester tester) async {
      const errorMessage = 'Invalid credentials';
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());
      whenListen(
        mockLoginCubit,
        Stream<LoginState>.fromIterable(
            [LoginLoading(), LoginFailure(errorMessage)]),
      );

      await pumpLoginScreen(tester);

      // Act
      await tester.pump(); // Processes state changes
      await tester
          .pump(const Duration(milliseconds: 500)); // Animates the SnackBar

      // Assert
      expect(find.textContaining(errorMessage), findsOneWidget);
    });
    testWidgets('calls login() on button tap when form is valid',
        (tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());
      when(() => mockLoginCubit.login(any(), any())).thenAnswer((_) async {});
      whenListen(
        mockLoginCubit,
        Stream<LoginState>.fromIterable([LoginInitial()]),
      );

      await pumpLoginScreen(tester);

      // Act
      await tester.pumpAndSettle(); // Wait for the UI to settle

      // Act
      final emailField = find.byKey(const Key('login_email_textfield'));
      final passwordField = find.byKey(const Key('login_password_textfield'));
      final loginButton = find.byKey(const Key('login_continue_button'));

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      await tester.pump();
      tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pump();

      // Assert
      verify(() => mockLoginCubit.login('test@example.com', 'password123'))
          .called(1);
    });

    testWidgets('navigates to SignUp screen on Join JobLinc tap',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());

      await pumpLoginScreen(tester);

      // Act
      await tester.pumpAndSettle(); // Wait for the UI to settle

      // Find the "Join JobLinc" TextSpan inside the RichText
      final gestureRecognizerFinder =
          find.byKey(const Key('joinJobLinc')).first;
      expect(gestureRecognizerFinder, findsOneWidget);

      // Tap the "Join JobLinc"
      await tester.tap(gestureRecognizerFinder);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sign Up Screen'), findsOneWidget);
    });

    testWidgets('navigates to ForgotPassword screen on tap',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());

      await pumpLoginScreen(tester);

      // Act
      await tester.pumpAndSettle(); // Wait for the UI to settle

      // Tap "Forgot Password?"
      final forgotPasswordText =
          find.byKey(const Key('login_forgotpassword_text')).first;
      expect(forgotPasswordText, findsOneWidget);
      await tester.ensureVisible(forgotPasswordText);
      await tester.tap(forgotPasswordText);
      //await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Debug print to check if the screen is rendered

      // Assert
      expect(find.text("Forgot Password"), findsOneWidget);
    });
  });
}
