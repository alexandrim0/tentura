import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'date_time_range.dart';
import 'user_entity.dart';

part 'beacon_entity.freezed.dart';

@freezed
class BeaconEntity with _$BeaconEntity {
  const factory BeaconEntity({
    required String id,
    required UserEntity author,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String title,
    @Default('') String context,
    @Default('') String description,
    @Default(false) bool hasPicture,
    @Default(false) bool isEnabled,
    DateTimeRange? timerange,
    LatLng? coordinates,
  }) = _BeaconEntity;

  const BeaconEntity._();

  String get imagePath => '';
}
