import 'package:drift/drift.dart';

class Accounts extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().withDefault(const Constant(''))();

  TextColumn get imageId => text().withDefault(const Constant(''))(); // v2

  TextColumn get blurHash => text().withDefault(const Constant(''))(); // v2

  IntColumn get height => integer().withDefault(const Constant(0))(); // v2

  IntColumn get width => integer().withDefault(const Constant(0))(); // v2

  // TBD: drop column in v3
  BoolColumn get hasAvatar => boolean().withDefault(const Constant(false))();

  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => {id};
}
