import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class User extends Table {
  TextColumn get id => text()();

  TextColumn get publicKey => text().unique()();

  TextColumn get title => text().withDefault(const Constant(''))();

  TextColumn get description => text().withDefault(const Constant(''))();

  BoolColumn get hasPicture => boolean().withDefault(const Constant(false))();

  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  TimestampColumn get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column> get primaryKey => {id};
}
