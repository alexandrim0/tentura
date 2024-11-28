import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show Status;

import 'package:tentura/consts.dart';

import 'schema/schema_versions.dart';
import 'tables/accounts.dart';
import 'tables/friends.dart';
import 'tables/messages.dart';
import 'tables/settings.dart';

export 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(
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

          await batch((b) {
            b.insertAll(
              settings,
              [
                SettingsCompanion.insert(
                  key: kSettingsThemeMode,
                  valueText: const Value('system'),
                ),
                SettingsCompanion.insert(
                  key: kSettingsIsIntroEnabledKey,
                  valueBool: const Value(true),
                ),
              ],
            );
          });
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
        onUpgrade: stepByStep(),
      );

  @disposeMethod
  Future<void> dispose() => super.close();
}
