import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/enum.dart';

import 'database.steps.dart';
import 'queries/_queries.dart';
import 'tables/_tables.dart';

export 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(
  queries: queries,
  tables: [
    Accounts,
    Friends,
    P2pMessages,
    Settings,
  ],
)
@singleton
final class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.addColumn(schema.accounts, schema.accounts.imageId);
        await m.addColumn(schema.accounts, schema.accounts.blurHash);
        await m.addColumn(schema.accounts, schema.accounts.height);
        await m.addColumn(schema.accounts, schema.accounts.width);

        await m.addColumn(schema.friends, schema.friends.imageId);
        await m.addColumn(schema.friends, schema.friends.blurHash);
        await m.addColumn(schema.friends, schema.friends.height);
        await m.addColumn(schema.friends, schema.friends.width);
      },
      from2To3: (m, schema) async {
        await customStatement('DROP TABLE messages');
        await m.dropColumn(schema.accounts, 'has_avatar');
        await m.dropColumn(schema.friends, 'has_avatar');

        await m.addColumn(schema.accounts, schema.accounts.fcmTokenUpdatedAt);
      },
    ),
  );

  @disposeMethod
  Future<void> dispose() => super.close();
}
