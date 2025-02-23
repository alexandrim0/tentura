import 'package:latlong2/latlong.dart';
import 'package:stormberry/stormberry.dart' hide DateTimeRange;

import 'package:tentura_root/domain/entity/date_time_range.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';

import '../service/converter/datetime_range_converter.dart';
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
        coordinates: lat == null || long == null ? null : LatLng(lat!, long!),
        author: (user as UserModel).asEntity,
      );
}

@Model(
  tableName: 'beacon',
  indexes: [
    TableIndex(
      name: 'beacon_author_id',
      columns: ['user_id'],
    ),
  ],
)
abstract class Beacon {
  @PrimaryKey()
  String get id;

  String get title;

  String get description;

  String? get context;

  User get user;

  DateTime get createdAt;

  DateTime get updatedAt;

  bool get enabled;

  bool get hasPicture;

  String get blurHash;

  int get picHeight;

  int get picWidth;

  double? get lat;

  double? get long;

  @UseConverter(DateTimeRangeConverter())
  DateTimeRange? get timerange;
}
