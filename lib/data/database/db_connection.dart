import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor dbConnect(String dbName) => driftDatabase(
      name: dbName,
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('/packages/sqlite3.wasm'),
        driftWorker: Uri.parse('/packages/drift_worker.js'),
      ),
    );
