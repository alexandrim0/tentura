import 'dart:async';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/app.dart';

Future<void> main() => SentryFlutter.init(
      (options) => options
        ..dsn = const String.fromEnvironment('SENTRY_URL')
        ..ignoreErrors = [
          'SocketException',
          'AuthenticationNotFoundException',
        ]
        ..tracesSampleRate = 1.0,
      appRunner: App.appRunner,
    );
