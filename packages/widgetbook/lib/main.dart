import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'deps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dependencyInit();
  runApp(const WidgetbookApp());
}
