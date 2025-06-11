import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'polling_variants.dart';
import 'users.dart';

class PollingActs extends Table {
  late final authorId = text().references(Users, #id)();

  late final pollingVariantId = customType(
    PgTypes.uuid,
  ).references(PollingVariants, #id)();

  late final createdAt = customType(
    PgTypes.timestampWithTimezone,
  ).clientDefault(() => PgDateTime(DateTime.timestamp()))();

  @override
  Set<Column<Object>> get primaryKey => {authorId, pollingVariantId};

  @override
  String get tableName => 'polling_act';

  @override
  bool get withoutRowId => true;
}
