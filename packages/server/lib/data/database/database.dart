import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'tables/_tables.dart';

export 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    User,
  ],
)
@singleton
final class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;

  @disposeMethod
  Future<void> dispose() => super.close();
}
