import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'package:tentura_server/consts.dart';

import 'date_time_range.dart';
import 'user_entity.dart';

part 'beacon_entity.freezed.dart';

@freezed
class BeaconEntity with _$BeaconEntity {
  const factory BeaconEntity({
    required String id,
    required String title,
    required UserEntity author,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String description,
    @Default(false) bool hasPicture,
    @Default(false) bool isEnabled,
    DateTimeRange? timerange,
    LatLng? coordinates,
    String? context,
  }) = _BeaconEntity;

  const BeaconEntity._();

  String get imagePath =>
      hasPicture ? '/images/${author.id}/$id.jpg' : kBeaconPlaceholderPath;
}
