import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

@module
abstract class RegisterModule {
  @singleton
  Logger get logger => Logger();

  @singleton
  SentryNavigatorObserver get sentryNavigatorObserver =>
      SentryNavigatorObserver();

  @singleton
  QueryExecutor get database => driftDatabase(
        name: 'main_db',
        native: const DriftNativeOptions(
          shareAcrossIsolates: true,
        ),
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('/packages/sqlite3.wasm'),
          driftWorker: Uri.parse('/packages/drift_worker.js'),
        ),
      );
}
