import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

final Size phonePortrait = Size(400, 800);
final Size iPadPortrait = Size(810, 1080);
final Size phoneLandscape = Size(800, 400);
final Size iPadLandscape = Size(1080, 810);

void renderTest(testWidget) {
  portraitRenderTest(testWidget);
  landscapeRenderTest(testWidget);
}

Widget createScaffold(Widget testWidget) {
  return ScreenUtilInit(
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
      tester.view.physicalSize = phonePortrait;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(testScaffold);
      });
      await tester.pumpAndSettle();

      tester.view.reset();
    });

    testWidgets('iPad portrait dimensions test', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = iPadPortrait;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(testScaffold);
      });
      await tester.pumpAndSettle();

      tester.view.reset();
    });
  });
}

void landscapeRenderTest(Widget testWidget) {
  Widget testScaffold = createScaffold(testWidget);
  group('Landscape render tests', () {
    testWidgets('Phone landscape dimensions test', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = phoneLandscape;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(testScaffold);
      });
      await tester.pumpAndSettle();

      tester.view.reset();
    });

    testWidgets('iPad landscape dimensions test', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = iPadLandscape;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(testScaffold);
      });
      await tester.pumpAndSettle();

      tester.view.reset();
    });
  });
}
