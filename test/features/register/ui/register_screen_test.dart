import 'dart:math';

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

}
