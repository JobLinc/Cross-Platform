import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';
import 'package:joblinc/features/signup/data/services/register_api_service.dart';
import 'package:joblinc/features/signup/ui/screens/signup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';
import 'package:joblinc/features/signup/ui/widgets/continue_sign_button.dart';
import 'package:joblinc/features/signup/ui/widgets/email_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/firstname_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/lastname_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/password_text_field.dart';
import 'package:dio/dio.dart';

void main() {
  testWidgets('hello world test', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: Text('Hello, world!'))));
    expect(find.text('Hello, world!'), findsOneWidget);
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

    expect(find.byType(FirstnameTextFormField), findsOneWidget);
    expect(find.byType(LastnameTextFormField), findsOneWidget);
    expect(find.byType(EmailTextFormField), findsOneWidget);
    expect(find.byType(PasswordTextFormField), findsOneWidget);
    expect(find.byType(ContinueSignButton), findsOneWidget);
  });

  testWidgets('SignupScreen form validation', (WidgetTester tester) async {
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

    await tester.enterText(find.byType(FirstnameTextFormField), 'John');
    await tester.enterText(find.byType(LastnameTextFormField), 'Doe');
    await tester.enterText(
        find.byType(EmailTextFormField), 'john.doe@example.com');
    await tester.enterText(find.byType(PasswordTextFormField), 'password123');

    await tester.tap(find.byType(ContinueSignButton));

    await tester.pump();

    // Add your expectations here
  });
}
