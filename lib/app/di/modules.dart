import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

@module
abstract class RegisterModule {
  @singleton
  SentryNavigatorObserver get sentryNavigatorObserver =>
      SentryNavigatorObserver();

  @singleton
  Logger get logger => Logger();
}
