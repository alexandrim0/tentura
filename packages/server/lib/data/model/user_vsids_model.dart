import 'package:stormberry/stormberry.dart';

import '../service/converter/timestamptz_converter.dart';
import 'user_model.dart';

part 'user_vsids_model.schema.dart';

@Model(tableName: 'user_vsids')
abstract class Vsids {
  User get user;

  @UseConverter(TimestamptzConverter())
  DateTime get updatedAt;

  int get counter;
}
