import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/changepassword/ui/screens/changepassword_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/changepassword/logic/cubit/change_password_cubit.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';

class MockChangePasswordCubit extends MockCubit<ChangePasswordState>
    implements ChangePasswordCubit {}

class FakeChangePasswordState extends Fake implements ChangePasswordState {}

void main() {
  late MockChangePasswordCubit mockChangePasswordCubit;

  setUpAll(() {
    registerFallbackValue(FakeChangePasswordState());
  });

  setUp(() {
    mockChangePasswordCubit = MockChangePasswordCubit();
    when(() => mockChangePasswordCubit.state)
        .thenReturn(ChangePasswordInitial());
    whenListen(
      mockChangePasswordCubit,
      Stream<ChangePasswordState>.fromIterable([ChangePasswordInitial()]),
    );
  });

  Future<void> pumpChangePasswordScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            routes: {
              '/profileScreen': (context) =>
                  const Scaffold(body: Text('Profile Screen')),
            },
            home: BlocProvider<ChangePasswordCubit>.value(
              value: mockChangePasswordCubit,
              child: ChangePasswordScreen(),
            ),
          );
        },
      ),
    );
  }

  group('ChangePasswordScreen Widget Tests', () {
    testWidgets(
        'displays loading in the button when state is ChangePasswordLoading',
        (tester) async {
      when(() => mockChangePasswordCubit.state)
          .thenReturn(ChangePasswordLoading());
      whenListen(
        mockChangePasswordCubit,
        Stream<ChangePasswordState>.fromIterable([ChangePasswordLoading()]),
      );
      await pumpChangePasswordScreen(tester);
      expect(find.text("Changing..."), findsOneWidget);
    });

    testWidgets('shows SnackBar and navigates on ChangePasswordSuccess',
        (tester) async {
      when(() => mockChangePasswordCubit.state)
          .thenReturn(ChangePasswordInitial());
      whenListen(
        mockChangePasswordCubit,
        Stream<ChangePasswordState>.fromIterable(
            [ChangePasswordLoading(), ChangePasswordSuccess()]),
      );
      await pumpChangePasswordScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Password changed successfully'), findsOneWidget);
    });

    testWidgets('shows error SnackBar on ChangePasswordFailure',
        (tester) async {
      const errorMessage = 'Change failed';
      when(() => mockChangePasswordCubit.state)
          .thenReturn(ChangePasswordInitial());
      whenListen(
        mockChangePasswordCubit,
        Stream<ChangePasswordState>.fromIterable(
            [ChangePasswordLoading(), ChangePasswordFailure(errorMessage)]),
      );
      await pumpChangePasswordScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining(errorMessage), findsOneWidget);
    });

    testWidgets('calls changePassword() on button tap when form is valid',
        (tester) async {
      when(() => mockChangePasswordCubit.state)
          .thenReturn(ChangePasswordInitial());
      when(() => mockChangePasswordCubit.changePassword(
            oldPassword: any(named: 'oldPassword'),
            newPassword: any(named: 'newPassword'),
          )).thenAnswer((_) async {});
      whenListen(
        mockChangePasswordCubit,
        Stream<ChangePasswordState>.fromIterable([ChangePasswordInitial()]),
      );
      await pumpChangePasswordScreen(tester);
      await tester.pumpAndSettle();

      final oldPasswordField =
          find.byKey(const Key('changePassword_currentPassword_textfield'));
      final newPasswordField =
          find.byKey(const Key('changePassword_newPassword_textfield'));
      final confirmPasswordField =
          find.byKey(const Key('changePassword_confirmPassword_textfield'));
      final changeButton =
          find.byKey(const Key('changePassword_submit_button'));

      await tester.enterText(oldPasswordField, 'oldPass');
      await tester.enterText(newPasswordField, 'newPass');
      await tester.enterText(confirmPasswordField, 'newPass');
      await tester.pump();
      await tester.ensureVisible(changeButton);
      await tester.tap(changeButton);
      await tester.pump();

      verify(() => mockChangePasswordCubit.changePassword(
            oldPassword: 'oldPass',
            newPassword: 'newPass',
          )).called(1);
    });
  });
}
