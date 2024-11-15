import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'db_connection.dart';
import 'tables/accounts.dart';
import 'tables/settings.dart';

export 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Settings,
  ],
)
@lazySingleton
final class Database extends _$Database {
  @factoryMethod
  Database.global() : super(dbConnect('database'));

  Database.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          // Create a bunch of default values on the first start.
          // await batch((b) {});
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  @disposeMethod
  Future<void> dispose() => super.close();
}
