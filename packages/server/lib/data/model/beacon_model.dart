import 'package:stormberry/stormberry.dart' hide DateRange;

import 'package:tentura_root/domain/entity/coordinates.dart';
import 'package:tentura_root/domain/entity/date_range.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';

import '../service/converter/date_range_converter.dart';
import '../service/converter/timestamptz_converter.dart';
import 'user_model.dart';

part 'beacon_model.schema.dart';

extension type const BeaconModel(BeaconView i) implements BeaconView {
  BeaconEntity get asEntity => BeaconEntity(
    id: id,
    title: title,
    context: context ?? '',
    description: description,
    hasPicture: hasPicture,
    picHeight: picHeight,
    picWidth: picWidth,
    blurHash: blurHash,
    isEnabled: enabled,
    createdAt: createdAt,
    updatedAt: updatedAt,
    timerange: timerange,
    coordinates:
        lat == null || long == null
            ? null
            : Coordinates(lat: lat!, long: long!),
    author: (user as UserModel).asEntity,
  );
}

@Model(
  tableName: 'beacon',
  indexes: [
    TableIndex(name: 'beacon_author_id', columns: ['user_id']),
  ],
)
abstract class Beacon {
  @PrimaryKey()
  String get id;

  String get title;

  String get description;

  String? get context;

  User get user;

  double? get lat;

  double? get long;

  bool get enabled;

  bool get hasPicture;

  String get blurHash;

  int get picHeight;

  int get picWidth;

  int get ticker;

  @UseConverter(DateRangeConverter())
  DateRange? get timerange;

  @UseConverter(TimestamptzConverter())
  DateTime get createdAt;

  @UseConverter(TimestamptzConverter())
  DateTime get updatedAt;
}
