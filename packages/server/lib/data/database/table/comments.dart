import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';

import '../common_fields.dart';
import 'beacons.dart';
import 'users.dart';

class Comments extends Table with TickerFields {
  late final id = text().clientDefault(() => CommentEntity.newId)();

  @ReferenceName('commentAuthor')
  late final userId = text().references(Users, #id)();

  @ReferenceName('parentBeacon')
  late final beaconId = text().references(Beacons, #id)();

  late final content = text().withLength(max: kDescriptionMaxLength)();

  late final createdAt =
      customType(
        PgTypes.timestampWithTimezone,
      ).clientDefault(() => PgDateTime(DateTime.timestamp()))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String get tableName => 'comment';

  @override
  bool get withoutRowId => true;
}
