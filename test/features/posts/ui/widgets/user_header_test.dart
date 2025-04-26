import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';

void main() {
  testWidgets('UserHeader displays username and headline',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        child: MaterialApp(
          home: UserHeader(
            imageURL: '',
            username: 'Test User',
            headline: 'Test Headline',
            senderID: '123',
          ),
        ),
      ),
    );

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Test Headline'), findsOneWidget);
  });
}