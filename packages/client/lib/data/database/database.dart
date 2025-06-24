import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/enum.dart';

import 'schema/schema_versions.dart';
import 'tables/_tables.dart';

export 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(
  include: {
    'queries.drift',
  },
  tables: [
    Accounts,
    Friends,
    Messages,
    Settings,
  ],
)
@singleton
final class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
    onUpgrade: stepByStep(),
  );

  @disposeMethod
  Future<void> dispose() => super.close();
}
