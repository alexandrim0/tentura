import 'dart:async';
import 'package:sentry/sentry.dart';

import 'package:tentura_server/app.dart';
import 'package:tentura_server/consts.dart';

Future<void> main(List<String> args) async {
  await Sentry.init(
    (options) => options
      ..dsn = kSentryDsn
      ..debug = kDebugMode
      ..ignoreErrors = [],
    appRunner: runApp,
  );
}
