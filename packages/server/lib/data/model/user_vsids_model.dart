import 'package:stormberry/stormberry.dart';

import 'user_model.dart';

part 'user_vsids_model.schema.dart';

@Model(tableName: 'user_vsids')
abstract class Vsids {
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  User get user;

  int get counter;
}
