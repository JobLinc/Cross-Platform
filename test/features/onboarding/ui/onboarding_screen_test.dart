import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/login/logic/cubit/login_state.dart';
import 'package:joblinc/core/routing/routes.dart';

// ------------------
// Mock & Fake Classes
// ------------------

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class FakeLoginState extends Fake implements LoginState {}

void main() {
  late MockLoginCubit mockLoginCubit;

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockLoginCubit = MockLoginCubit();

    // Return a default state
    when(() => mockLoginCubit.state).thenReturn(LoginInitial());

    // Mock the loginWithGoogle method
    when(() => mockLoginCubit.loginWithGoogle()).thenAnswer((_) async {});

    // Return an empty stream or emit states if needed
    whenListen(
      mockLoginCubit,
      Stream<LoginState>.fromIterable([LoginInitial()]),
    );
  });

  Future<void> pumpOnboardingScreen(WidgetTester tester) async {
    // Set a device size to avoid overflow issues
    tester.binding.window.physicalSizeTestValue = const Size(1080, 2340);
    tester.binding.window.devicePixelRatioTestValue = 3.0;

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          Routes.homeScreen: (context) =>
              const Scaffold(body: Text('Home Screen')),
          Routes.loginScreen: (context) =>
              const Scaffold(body: Text('Login Screen')),
          Routes.signUpScreen: (context) =>
              const Scaffold(body: Text('Sign Up Screen')),
          Routes.emailConfirmationScreen: (context) => const Scaffold(
                body: Text('Email Confirmation Screen'),
              ),
        },
        home: ScreenUtilInit(
          designSize: const Size(412, 924),
          minTextAdapt: true,
          builder: (context, child) {
            return BlocProvider<LoginCubit>.value(
              value: mockLoginCubit,
              child: const OnboardingScreen(),
            );
          },
        ),
      ),
    );

    // Wait for any post-frame callbacks to complete
    await tester.pumpAndSettle();
  }

  group('OnboardingScreen Widget Tests', () {
    testWidgets('renders all UI elements correctly',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());

      // Act
      await pumpOnboardingScreen(tester);

      // Assert
      expect(
          find.image(const AssetImage('assets/images/JobLinc_logo_light.png')),
          findsOneWidget);
      expect(find.text('Join a trusted community of 1B professionals'),
          findsOneWidget);
      expect(find.text('Sign in with email '), findsOneWidget);
      expect(find.text('Continue with google'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
      expect(find.text('Agree & Join'), findsOneWidget);
    });

    testWidgets('navigates to login screen when Sign in with email is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());

      // Act
      await pumpOnboardingScreen(tester);
      await tester.tap(find.text('Sign in with email '));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('navigates to signup screen when Agree & Join is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());

      // Act
      await pumpOnboardingScreen(tester);
      await tester.tap(find.text('Agree & Join'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sign Up Screen'), findsOneWidget);
    });

    testWidgets('calls loginWithGoogle when Continue with google is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());

      // Act
      await pumpOnboardingScreen(tester);
      await tester.tap(find.text('Continue with google'));
      await tester.pump();

      // Assert
      verify(() => mockLoginCubit.loginWithGoogle()).called(1);
    });

    testWidgets('shows SnackBar and navigates on LoginSuccess',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());
      whenListen(
        mockLoginCubit,
        Stream<LoginState>.fromIterable([LoginLoading(), LoginSuccess()]),
      );

      // Act
      await pumpOnboardingScreen(tester);
      await tester.pump(); // Process state changes
      await tester.pump(const Duration(milliseconds: 500)); // Animate SnackBar

      // Assert
      expect(find.text('Login successful'), findsOneWidget);
      await tester.pumpAndSettle(); // Wait for navigation
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('shows error SnackBar on LoginFailure',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Google authentication failed';
      when(() => mockLoginCubit.state).thenReturn(LoginInitial());
      whenListen(
        mockLoginCubit,
        Stream<LoginState>.fromIterable(
            [LoginLoading(), LoginFailure(errorMessage)]),
      );

      // Act
      await pumpOnboardingScreen(tester);
      await tester.pump(); // Process state changes
      await tester.pump(const Duration(milliseconds: 500)); // Animate SnackBar

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
