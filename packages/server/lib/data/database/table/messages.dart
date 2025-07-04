import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import '../common_fields.dart';
import 'users.dart';

class Messages extends Table with TimestampsFields {
  late final id = customType(PgTypes.uuid).withDefault(genRandomUuid())();

  @ReferenceName('subject')
  late final subject = text().references(Users, #id)();

  @ReferenceName('object')
  late final object = text().references(Users, #id)();

  late final message = text()();

  late final delivered = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String get tableName => 'message';

  @override
  bool get withoutRowId => true;
}
