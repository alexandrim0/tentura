import 'dart:async';

import 'package:tentura_server/app.dart';

Future<void> main(List<String> args) async {
  await App(
    env: Environment.test,
    numberOfIsolates: 1,
  ).run();
}
