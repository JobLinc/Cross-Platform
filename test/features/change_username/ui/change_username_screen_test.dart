import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/changeusername/logic/cubit/change_username_cubit.dart';
import 'package:joblinc/features/changeusername/ui/screens/changeusername_screen.dart';

class MockChangeUsernameCubit extends MockCubit<ChangeUsernameState>
    implements ChangeUsernameCubit {}

class FakeChangeUsernameState extends Fake implements ChangeUsernameState {}

void main() {
  late MockChangeUsernameCubit mockChangeUsernameCubit;

  setUpAll(() {
    registerFallbackValue(FakeChangeUsernameState());
  });

  setUp(() {
    mockChangeUsernameCubit = MockChangeUsernameCubit();
    when(() => mockChangeUsernameCubit.state)
        .thenReturn(ChangeUsernameInitial());
    whenListen(
      mockChangeUsernameCubit,
      Stream<ChangeUsernameState>.fromIterable([ChangeUsernameInitial()]),
    );
  });

  Future<void> pumpChangeUsernameScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider<ChangeUsernameCubit>.value(
              value: mockChangeUsernameCubit,
              child: ChangeUsernameScreen(),
            ),
          );
        },
      ),
    );
  }

  group('ChangeUsernameScreen Widget Tests', () {
    testWidgets(
        'displays loading in the button when state is ChangeUsernameLoading',
        (tester) async {
      when(() => mockChangeUsernameCubit.state)
          .thenReturn(ChangeUsernameLoading());
      whenListen(
        mockChangeUsernameCubit,
        Stream<ChangeUsernameState>.fromIterable([ChangeUsernameLoading()]),
      );
      await pumpChangeUsernameScreen(tester);
      expect(find.text("Changing..."), findsOneWidget);
    });

    testWidgets('shows SnackBar and pops on ChangeUsernameSuccess',
        (tester) async {
      when(() => mockChangeUsernameCubit.state)
          .thenReturn(ChangeUsernameInitial());
      whenListen(
        mockChangeUsernameCubit,
        Stream<ChangeUsernameState>.fromIterable(
            [ChangeUsernameLoading(), ChangeUsernameSuccess()]),
      );
      await pumpChangeUsernameScreen(tester);
      await tester.pump();
      expect(find.text('Username changed successfully'), findsOneWidget);
    });

    testWidgets('shows error SnackBar on ChangeUsernameFailure',
        (tester) async {
      const errorMessage = 'Change failed';
      when(() => mockChangeUsernameCubit.state)
          .thenReturn(ChangeUsernameInitial());
      whenListen(
        mockChangeUsernameCubit,
        Stream<ChangeUsernameState>.fromIterable(
            [ChangeUsernameLoading(), ChangeUsernameFailure(errorMessage)]),
      );
      await pumpChangeUsernameScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining(errorMessage), findsOneWidget);
    });

    testWidgets('calls changeUsername() on button tap when form is valid',
        (tester) async {
      when(() => mockChangeUsernameCubit.state)
          .thenReturn(ChangeUsernameInitial());
      when(() => mockChangeUsernameCubit.changeUsername(
            newUsername: any(named: 'newUsername'),
          )).thenAnswer((_) async {});
      whenListen(
        mockChangeUsernameCubit,
        Stream<ChangeUsernameState>.fromIterable([ChangeUsernameInitial()]),
      );
      await pumpChangeUsernameScreen(tester);
      await tester.pumpAndSettle();

      final newUsernameField =
          find.byKey(const Key('changeUsername_newUsername_textfield'));
      final changeButton =
          find.byKey(const Key('changeUsername_submit_button'));

      await tester.enterText(newUsernameField, 'newusername');
      await tester.pump();
      await tester.ensureVisible(changeButton);
      await tester.tap(changeButton);
      await tester.pump();

      verify(() => mockChangeUsernameCubit.changeUsername(
            newUsername: 'newusername',
          )).called(1);
    });
  });
}
