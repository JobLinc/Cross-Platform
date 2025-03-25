import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_state.dart';
import 'package:joblinc/features/forgetpassword/ui/screens/forgetpassword_screen.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';

// ------------------
// Mock & Fake Classes
// ------------------

class MockForgotPasswordCubit extends MockCubit<ForgotPasswordState>
    implements ForgetPasswordCubit {}

class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}

void main() {
  late MockForgotPasswordCubit mockForgotPasswordCubit;

  setUpAll(() {
    registerFallbackValue(FakeForgotPasswordState());
  });

  setUp(() {
    mockForgotPasswordCubit = MockForgotPasswordCubit();

    // Return a default state
    when(() => mockForgotPasswordCubit.state)
        .thenReturn(ForgotPasswordInitial());

    // Return an empty stream or emit states if needed
    whenListen(
      mockForgotPasswordCubit,
      Stream<ForgotPasswordState>.fromIterable([ForgotPasswordInitial()]),
    );
  });

  Future<void> pumpForgotPasswordScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider<ForgetPasswordCubit>.value(
              value: mockForgotPasswordCubit,
              child: ForgotPasswordSteps(),
            ),
          );
        },
      ),
    );
  }

  group('ForgotPasswordScreen Widget Tests', () {
    testWidgets('shows success message on ForgotPasswordSuccess',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockForgotPasswordCubit.state)
          .thenReturn(ForgotPasswordInitial());
      whenListen(
        mockForgotPasswordCubit,
        Stream<ForgotPasswordState>.fromIterable(
            [ForgotPasswordLoading(), ForgotPasswordSuccess()]),
      );

      await pumpForgotPasswordScreen(tester);

      // Act
      await tester.pump(); // Processes state changes

      // Assert
      expect(find.text('Password reset successfully!'), findsOneWidget);
    });

    testWidgets('shows error message on ForgotPasswordFailure',
        (WidgetTester tester) async {
      const errorMessage = 'Invalid email address';
      // Arrange
      when(() => mockForgotPasswordCubit.state)
          .thenReturn(ForgotPasswordInitial());
      whenListen(
        mockForgotPasswordCubit,
        Stream<ForgotPasswordState>.fromIterable(
            [ForgotPasswordLoading(), ForgotPasswordError(errorMessage)]),
      );

      await pumpForgotPasswordScreen(tester);

      // Act
      await tester.pump(); // Processes state changes
      await tester
          .pump(const Duration(milliseconds: 500)); // Animates the SnackBar

      // Assert
      expect(find.textContaining(errorMessage), findsOneWidget);
    });
  });
}
