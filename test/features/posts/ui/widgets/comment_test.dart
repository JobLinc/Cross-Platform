import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/posts/ui/widgets/comment.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';

void main() {
  testWidgets('Comment displays User Header and text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        child: MaterialApp(
          home: SingleChildScrollView(child: Comment(data: mockCommentData)),
        ),
      ),
    );

    expect(find.byType(UserHeader), findsOneWidget);
    expect(find.text(mockCommentData.text), findsOneWidget);
    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Reply'), findsOneWidget);
  });
}