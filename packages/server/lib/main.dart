import 'dart:async';
import 'package:sentry/sentry.dart';

import 'app.dart';
import 'consts.dart';

Future<void> main() async {
  await Sentry.init(
    (options) => options
      ..dsn = kSentryDsn
      ..debug = kDebugMode
      ..ignoreErrors = [],
    appRunner: runApp,
  );
}
