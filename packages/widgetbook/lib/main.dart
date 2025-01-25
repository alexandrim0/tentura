import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tentura/ui/utils/asset_package.dart';

import 'app.dart';
import 'di.dart';

void main() async {
  AssetPackage.assetPackage = 'tentura';
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await configureDependencies();
  runApp(const WidgetbookApp());
}
