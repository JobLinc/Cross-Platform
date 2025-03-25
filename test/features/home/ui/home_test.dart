import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../../../core/test_utils.dart';

Widget testWidget = createScaffold(HomeScreen());

Future<void> pumpHomeScreen(WidgetTester tester) async {
  await mockNetworkImagesFor(() async {
    await tester.pumpWidget(testWidget);
  });
  await tester.pumpAndSettle();
}

void main() {
  group('Home test start:', () {
    testWidgets('Render test', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.text('Tyrone'), findsAny);
    });

    testWidgets('Profile button test', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.byKey(Key('home_topBar_profile')), findsOne);
      await tester.tap(find.byKey(Key('home_topBar_profile')));
      await tester.pumpAndSettle();
      expect(find.text('View my connections'), findsAny);
    });
  });
}
