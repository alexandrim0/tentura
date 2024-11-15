import 'package:drift/drift.dart';

class Friends extends Table {
  TextColumn get subject => text()();
  TextColumn get object => text()();
  TextColumn get title => text().withDefault(const Constant(''))();
  BoolColumn get hasAvatar => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {subject, object};
}
