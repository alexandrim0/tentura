import 'package:injectable/injectable.dart' show Environment;

import 'package:tentura_server/di/di.dart' as t;

import 'consts.dart';

Future<void> configureDependencies([String? envName]) =>
    t.configureDependencies(
      envName ?? (kIsIntegrationTest ? Environment.dev : Environment.test),
    );
