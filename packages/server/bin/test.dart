import 'dart:io';
import 'package:injectable/injectable.dart' show Environment;

import 'package:tentura_server/app/app.dart';
import 'package:tentura_server/env.dart';

Future<void> main(List<String> args) async {
  await const App().run(Env(environment: Environment.test));
  exit(0);
}
