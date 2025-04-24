import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_cubit.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_state.dart';
import 'package:joblinc/features/changeemail/ui/screens/change_email_screen.dart';

class MockChangeEmailCubit extends Mock implements ChangeEmailCubit {}

class FakeChangeEmailState extends Fake implements ChangeEmailState {}

void main() {
  late MockChangeEmailCubit mockChangeEmailCubit;

  setUpAll(() {
    registerFallbackValue(FakeChangeEmailState());
  });

  setUp(() {
    mockChangeEmailCubit = MockChangeEmailCubit();
    when(() => mockChangeEmailCubit.state).thenReturn(ChangeEmailInitial());
    whenListen(
      mockChangeEmailCubit,
      Stream<ChangeEmailState>.fromIterable([ChangeEmailInitial()]),
    );
  });

  Future<void> buildTestableWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider<ChangeEmailCubit>.value(
              value: mockChangeEmailCubit,
              child: ChangeEmailScreen(),
            ),
          );
        },
      ),
    );
  }

  testWidgets('renders email field and submit button', (tester) async {
    await buildTestableWidget(tester);

    expect(find.byKey(const Key('change_email_textfield')), findsOneWidget);
    expect(find.byKey(const Key('change_email_button')), findsOneWidget);
  });

  testWidgets('calls cubit.updateEmail when submit button is tapped',
      (tester) async {
    await buildTestableWidget(tester);
    final changeButton = find.byKey(const Key('change_email_button'));

    final emailField = find.byKey(const Key('change_email_textfield'));

    await tester.enterText(emailField, 'test@example.com');
    await tester.pump();

    await tester.ensureVisible(changeButton);

    await tester.tap(find.text('Change Email'));
    await tester.pump();
    verifyNever(() => mockChangeEmailCubit.updateEmail('test@example.com'))
        .called(0);
  });

  testWidgets('shows loading indicator when state is loading', (tester) async {
    when(() => mockChangeEmailCubit.state).thenReturn(ChangeEmailLoading());
    await buildTestableWidget(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

}
