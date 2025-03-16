import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/home/data/models/post_model.dart';
import 'package:joblinc/features/home/ui/widgets/post_widget.dart';
import 'package:network_image_mock/network_image_mock.dart';

Widget testWidget = MaterialApp(
  home: Scaffold(
    body: ListView(
      children: [
        Post(data: mockData),
      ],
    ),
  ),
);

void main() {
  group('Post test start:', () {
    testWidgets('Load and Render test', (tester) async {
      await mockNetworkImagesFor(() async {
        return tester.pumpWidget(testWidget);
      });
      await tester.pumpAndSettle();
    });

    testWidgets('button test', (tester) async {
      await mockNetworkImagesFor(() async {
        return tester.pumpWidget(testWidget);
      });
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel(RegExp(r'(post_actionBar_like)')));
      await tester
          .tap(find.bySemanticsLabel(RegExp(r'(post_actionBar_comment)')));
      await tester
          .tap(find.bySemanticsLabel(RegExp(r'(post_actionBar_repost)')));
      await tester
          .tap(find.bySemanticsLabel(RegExp(r'(post_actionBar_share)')));
    });
  });
}
