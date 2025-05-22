import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/entity/opinion_entity.dart';

import '../common_fields.dart';
import 'users.dart';

class Opinions extends Table with TickerFields {
  late final id = text().clientDefault(() => OpinionEntity.newId)();

  @ReferenceName('opinionSubject')
  late final subject = text().references(Users, #id)();

  @ReferenceName('opinionObject')
  late final object = text().references(Users, #id)();

  late final content = text().withLength(max: kDescriptionMaxLength)();

  late final amount = integer()();

  late final createdAt =
      customType(
        PgTypes.timestampWithTimezone,
      ).clientDefault(() => PgDateTime(DateTime.timestamp()))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String get tableName => 'opinion';

  @override
  bool get withoutRowId => true;
}
