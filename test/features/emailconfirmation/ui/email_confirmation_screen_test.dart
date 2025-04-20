import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_cubit.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_state.dart';
import 'package:joblinc/features/emailconfirmation/ui/screens/email_confirmation_screen.dart';

class MockEmailConfirmationCubit extends MockCubit<EmailConfirmationState>
    implements EmailConfirmationCubit {}

class FakeEmailConfirmationState extends Fake implements EmailConfirmationState {}

void main() {
  late MockEmailConfirmationCubit mockEmailConfirmationCubit;

  setUpAll(() {
    registerFallbackValue(FakeEmailConfirmationState());
  });

  setUp(() {
    mockEmailConfirmationCubit = MockEmailConfirmationCubit();
    when(() => mockEmailConfirmationCubit.state)
        .thenReturn(EmailConfirmationInitial());
    whenListen(
      mockEmailConfirmationCubit,
      Stream<EmailConfirmationState>.fromIterable([EmailConfirmationInitial()]),
    );
  });

  Future<void> pumpEmailConfirmationScreen(WidgetTester tester,
      {String email = 'test@example.com'}) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider<EmailConfirmationCubit>.value(
              value: mockEmailConfirmationCubit,
              child: EmailConfirmationScreen(email: email),
            ),
          );
        },
      ),
    );
  }

  group('EmailConfirmationScreen Widget Tests', () {
    testWidgets(
        'shows loading overlay when state is EmailConfirmationLoading',
        (tester) async {
      when(() => mockEmailConfirmationCubit.state)
          .thenReturn(EmailConfirmationLoading());
      whenListen(
        mockEmailConfirmationCubit,
        Stream<EmailConfirmationState>.fromIterable([EmailConfirmationLoading()]),
      );
      await pumpEmailConfirmationScreen(tester);
       
     expect(find.byType(LoadingIndicatorOverlay), findsOneWidget);
    });

    testWidgets('shows SnackBar and OTP field on EmailConfirmationOtpSent',
        (tester) async {
      when(() => mockEmailConfirmationCubit.state)
          .thenReturn(EmailConfirmationInitial());
      whenListen(
        mockEmailConfirmationCubit,
        Stream<EmailConfirmationState>.fromIterable(
            [EmailConfirmationOtpSent('OTP sent', 'test@example.com')]),
      );
      await pumpEmailConfirmationScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('OTP sent'), findsOneWidget);
      // OTP field should be visible
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byKey(const Key('verify_code_button')), findsOneWidget);
    });


    testWidgets('shows error SnackBar on EmailConfirmationFailure',
        (tester) async {
      const errorMessage = 'Verification failed';
      when(() => mockEmailConfirmationCubit.state)
          .thenReturn(EmailConfirmationInitial());
      whenListen(
        mockEmailConfirmationCubit,
        Stream<EmailConfirmationState>.fromIterable(
            [EmailConfirmationLoading(), EmailConfirmationFailure(errorMessage)]),
      );
      await pumpEmailConfirmationScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining(errorMessage), findsOneWidget);
    });

    testWidgets('calls verifyEmail() on verify button tap when OTP is valid',
        (tester) async {
      when(() => mockEmailConfirmationCubit.state)
          .thenReturn(EmailConfirmationOtpSent('OTP sent', 'test@example.com'));
      when(() => mockEmailConfirmationCubit.verifyEmail(
            email: any(named: 'email'),
            otp: any(named: 'otp'),
          )).thenAnswer((_) async {});
      whenListen(
        mockEmailConfirmationCubit,
        Stream<EmailConfirmationState>.fromIterable([
          EmailConfirmationOtpSent('OTP sent', 'test@example.com')
        ]),
      );
      await pumpEmailConfirmationScreen(tester);
      await tester.pumpAndSettle();

      final otpField = find.byType(TextField);
      final verifyButton = find.byKey(const Key('verify_code_button'));

      await tester.enterText(otpField, '123456');
      await tester.pump();
      await tester.ensureVisible(verifyButton);
      await tester.tap(verifyButton);
      await tester.pump();

      verify(() => mockEmailConfirmationCubit.verifyEmail(
            email: 'test@example.com',
            otp: '123456',
          )).called(1);
    });

    testWidgets('calls resendConfirmationEmail() on resend button tap',
        (tester) async {
      when(() => mockEmailConfirmationCubit.state)
          .thenReturn(EmailConfirmationInitial());
      when(() => mockEmailConfirmationCubit.resendConfirmationEmail(any()))
          .thenAnswer((_) async {});
      await pumpEmailConfirmationScreen(tester);
      await tester.pumpAndSettle();

      final resendButton = find.text('Resend confirmation code');
      await tester.tap(resendButton);
      await tester.pump();

      verify(() => mockEmailConfirmationCubit.resendConfirmationEmail('test@example.com')).called(1);
    });
  });
}
