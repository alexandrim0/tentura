import 'package:drift/drift.dart';

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withDefault(const Constant(''))();
  BoolColumn get hasPicture => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
