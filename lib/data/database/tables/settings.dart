import 'package:drift/drift.dart';

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get valueText => text().nullable()();
  IntColumn get valueInt => integer().nullable()();
  BoolColumn get valueBool => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
