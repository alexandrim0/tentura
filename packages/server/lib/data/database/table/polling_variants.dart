import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'pollings.dart';

class PollingVariants extends Table {
  late final id = customType(PgTypes.uuid).withDefault(genRandomUuid())();

  late final pollingId = text().references(Pollings, #id)();

  late final description = text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String get tableName => 'polling_variant';

  @override
  bool get withoutRowId => true;
}
