import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/home/data/models/post_model.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/home/ui/widgets/post_widget.dart';
import 'package:joblinc/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:network_image_mock/network_image_mock.dart';

Size phone = Size(400, 800);
Size iPad = Size(810, 1080);

void main() {
  renderTest(HomeScreen());
}

void renderTest(testWidget) {
  portraitRenderTest(testWidget);
  landscapeRenderTest(testWidget);
}

Widget createScaffold(Widget testWidget) {
  return ScreenUtilInit(
    designSize: Size(412, 924),
    minTextAdapt: true,
    builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(fontFamily: 'Roboto'),
        home: testWidget,
      );
    },
  );
}

void portraitRenderTest(Widget testWidget) {
  Widget testScaffold = createScaffold(testWidget);
  group('Portrait render tests', () {
    testWidgets('Phone portrait dimensions test', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = phone;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(testScaffold);
      });
      await tester.pumpAndSettle();
      await expectLater(
        find.byWidget(testWidget),
        matchesGoldenFile('portrait/phone.png'),
      );

      tester.view.reset();
    });

    testWidgets('iPad portrait dimensions test', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = iPad;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(testScaffold);
      });
      await tester.pumpAndSettle();
      await expectLater(
        find.byWidget(testWidget),
        matchesGoldenFile('portrait/iPad.png'),
      );

      tester.view.reset();
    });
  });
}

void landscapeRenderTest(Widget testWidget) {
  Widget testScaffold = createScaffold(testWidget);
}
