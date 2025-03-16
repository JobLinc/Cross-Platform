import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../../../core/render_test.dart';

void main() {
  group('Post test start:', () {
    renderTest(HomeScreen());

    testWidgets('button test', (tester) async {
      Widget testWidget = createScaffold(HomeScreen());
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
