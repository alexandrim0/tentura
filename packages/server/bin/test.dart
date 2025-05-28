import 'dart:async';

import 'package:tentura_server/app.dart';
import 'package:tentura_server/domain/enum.dart';

Future<void> main(List<String> args) async {
  await App(env: Environment.test, numberOfIsolates: 1).run();
}
