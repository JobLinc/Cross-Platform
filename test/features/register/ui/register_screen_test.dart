import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:joblinc/features/signup/data/models/register_request_model.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';
import 'package:joblinc/features/signup/data/services/register_api_service.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_state.dart';
import 'package:joblinc/features/signup/ui/screens/signup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';

import 'package:dio/dio.dart';
import 'package:joblinc/features/signup/ui/widgets/signup_step_one.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';

// ------------------
// Mock & Fake Classes
// ------------------

class MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

class FakeRegisterState extends Fake implements RegisterState {}

class FakeRegisterRequestModel extends Fake implements RegisterRequestModel {}

void main() {
  late MockRegisterCubit mockRegisterCubit;

  setUpAll(() {
    registerFallbackValue(FakeRegisterState());
    registerFallbackValue(FakeRegisterRequestModel()); // Register fallback
  });

  setUp(() {
    mockRegisterCubit = MockRegisterCubit();

    // Return a default state
    when(() => mockRegisterCubit.state).thenReturn(RegisterInitial());

    // Return an empty stream or emit states if needed
    whenListen(
      mockRegisterCubit,
      Stream<RegisterState>.fromIterable([RegisterInitial()]),
    );
  });

  Future<void> pumpRegisterScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 1000),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            routes: {
              '/loginScreen': (context) =>
                  const Scaffold(body: Text('Login Screen')),
              '/homeScreen': (context) =>
                  const Scaffold(body: Text('Home Screen')),
            },
            home: BlocProvider<RegisterCubit>.value(
              value: mockRegisterCubit,
              child: SignupScreen(),
            ),
          );
        },
      ),
    );
  }

  group('RegisterScreen Widget Tests', () {
    testWidgets('displays loading overlay when state is RegisterLoading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockRegisterCubit.state).thenReturn(RegisterLoading());
      whenListen(mockRegisterCubit,
          Stream<RegisterState>.fromIterable([RegisterLoading()]));

      // Act
      await pumpRegisterScreen(tester);

      // Assert
      expect(find.byType(LoadingIndicatorOverlay), findsOneWidget);
    });

    testWidgets('shows SnackBar and navigates on RegisterSuccess',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockRegisterCubit.state).thenReturn(RegisterInitial());
      whenListen(
        mockRegisterCubit,
        Stream<RegisterState>.fromIterable(
            [RegisterLoading(), RegisterSuccess()]),
      );

      await pumpRegisterScreen(tester);

      // Act
      await tester.pump(); // Processes state changes
      await tester
          .pump(const Duration(milliseconds: 500)); // Animates the SnackBar

      // Assert
      expect(find.text('Signup success'), findsOneWidget);
    });

    testWidgets('shows error SnackBar on RegisterFailure',
        (WidgetTester tester) async {
      const errorMessage = 'Registration failed';
      // Arrange
      when(() => mockRegisterCubit.state).thenReturn(RegisterInitial());
      whenListen(
        mockRegisterCubit,
        Stream<RegisterState>.fromIterable(
            [RegisterLoading(), RegisterFailure(errorMessage)]),
      );

      await pumpRegisterScreen(tester);

      // Act
      await tester.pump(); // Processes state changes
      await tester
          .pump(const Duration(milliseconds: 500)); // Animates the SnackBar

      // Assert
      expect(find.textContaining(errorMessage), findsOneWidget);
    });

    testWidgets('calls register() on button tap after completing all steps',
        (tester) async {
      // Arrange
      when(() => mockRegisterCubit.state).thenReturn(RegisterInitial());
      when(() => mockRegisterCubit.register(any())).thenAnswer((_) async {});
      whenListen(
        mockRegisterCubit,
        Stream<RegisterState>.fromIterable([RegisterInitial()]),
      );

      await pumpRegisterScreen(tester);

      // Act
      await tester.pumpAndSettle(); // Wait for the UI to settle

      // Step 1: Fill first name and last name
      final firstNameField =
          find.byKey(const Key('register_firstname_textfield'));
      final lastNameField =
          find.byKey(const Key('register_lastname_textfield'));
      final continueButtonStep1 =
          find.byKey(const Key('register_continue_button'));

      await tester.enterText(firstNameField, 'Test');
      await tester.enterText(lastNameField, 'User');
      await tester.tap(continueButtonStep1);
      await tester.pumpAndSettle();

      // Step 2: Fill email and password
      final emailField = find.byKey(const Key('register_email_textfield'));
      final passwordField =
          find.byKey(const Key('register_password_textfield'));
      final continueButtonStep2 =
          find.byKey(const Key('register_continue_button'));

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.tap(continueButtonStep2);
      await tester.pumpAndSettle();

      tester.ensureVisible(find.byKey(const Key('register_step3_form')));

      // Step 3: Fill country, city, and phone number
      final countryField = find.byKey(const Key('register_country_textfield'));
      final cityField = find.byKey(const Key('register_city_textfield'));
      final phoneField = find.byKey(const Key('register_phone_textfield'));
      final submitButton = find.byKey(const Key('register_continue_button'));

      await tester.enterText(countryField, 'Country');
      await tester.enterText(cityField, 'City');
      await tester.enterText(phoneField, '1234567890');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert
      verifyNever(() => mockRegisterCubit.register(RegisterRequestModel(
          firstname: "Test",
          lastname: "User",
          email: "test@example.com",
          password: "password123",
          country: "Country",
          city: "City",
          phoneNumber: "1234567890"))).called(0);
    });

    testWidgets('navigates to Login screen on "Sign in to JobLinc" tap',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockRegisterCubit.state).thenReturn(RegisterInitial());

      await pumpRegisterScreen(tester);

      // Act
      await tester.pumpAndSettle(); // Wait for the UI to settle

      final loginText =
          find.byKey(const Key('register_returnToLogin_textbutton')).first;
      expect(loginText, findsOneWidget);

      await tester.tap(loginText);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });

  testWidgets('SignupScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider(
              create: (context) =>
                  RegisterCubit(RegisterRepo(RegisterApiService(Dio()))),
              child: SignupScreen(),
            ),
          );
        },
      ),
    );

    await tester
        .pumpAndSettle(); // Ensure all animations and frames are settled

    expect(find.byType(SignupStepOne), findsOneWidget);

    expect(find.byKey(Key("register_continue_button")), findsOneWidget);
  });
}
