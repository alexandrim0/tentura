import 'package:drift/drift.dart';

class Friends extends Table {
  TextColumn get subjectId => text()();

  TextColumn get objectId => text()();

  TextColumn get title => text().withDefault(const Constant(''))();

  BoolColumn get hasAvatar => boolean().withDefault(const Constant(false))();

  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => {subjectId, objectId};
}
