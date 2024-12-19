import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

part 'database.g.dart';

@DriftDatabase(
  include: {},
  tables: [],
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
      );

  @disposeMethod
  Future<void> dispose() => super.close();
}
