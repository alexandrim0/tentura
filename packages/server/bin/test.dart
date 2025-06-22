import 'dart:io';

import 'package:tentura_server/app/app.dart';

Future<void> main(List<String> args) async {
  await const App().runTest();
  exit(0);
}
