import 'package:drift/drift.dart';

import 'package:tentura_server/domain/entity/polling_entity.dart';

import '../common_fields.dart';
import 'users.dart';

class Pollings extends Table with TimestampsFields {
  late final id = text().clientDefault(() => PollingEntity.newId)();

  late final authorId = text().references(Users, #id)();

  late final question = text()();

  late final isEnabled = boolean()
      .named('enabled')
      .withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String get tableName => 'polling';

  @override
  bool get withoutRowId => true;
}
