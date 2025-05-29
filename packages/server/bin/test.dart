import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/app.dart';
import 'package:tentura_server/env.dart';

Future<void> main(List<String> args) async {
  await const App().run(Env(environment: Environment.test));
}
