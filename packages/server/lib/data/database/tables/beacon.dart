import 'package:stormberry/stormberry.dart' hide DateTimeRange;

import 'package:tentura_server/domain/entity/date_time_range.dart';

import '../converter/datetime_range_converter.dart';
import 'user.dart';

part 'beacon.schema.dart';

@Model(
  tableName: 'beacon',
)
abstract class Beacon {
  @PrimaryKey()
  String get id;

  String get title;

  String get description;

  String? get context;

  User get userId;

  DateTime get createdAt;

  DateTime get updatedAt;

  bool get enabled;

  bool get hasPicture;

  double get lat;

  double get long;

  @UseConverter(DateTimeRangeConverter())
  DateTimeRange get timerange;
}
