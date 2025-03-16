import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final roboto = rootBundle.load('assets/fonts/Roboto-Regular.ttf');

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() async {
    final FontLoader fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });
  await testMain();
}
