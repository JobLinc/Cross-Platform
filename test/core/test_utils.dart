import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final Size phonePortrait = Size(400, 800);
final Size iPadPortrait = Size(810, 1080);
final Size phoneLandscape = Size(800, 400);
final Size iPadLandscape = Size(1080, 810);

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
