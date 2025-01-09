import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/app.dart';

Future<void> main(List<String> args) async {
  await runApp(
    env: Environment.test,
  );
}
