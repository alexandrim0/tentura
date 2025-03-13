import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'package:tentura_root/domain/entity/date_time_range.dart';
import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';

import 'user_entity.dart';

part 'beacon_entity.freezed.dart';

@freezed
class BeaconEntity with _$BeaconEntity {
  static String get newId => generateId('B');

  const factory BeaconEntity({
    required String id,
    required String title,
    required UserEntity author,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isEnabled,
    @Default(false) bool hasPicture,
    @Default('') String description,
    @Default('') String blurHash,
    @Default(0) int picHeight,
    @Default(0) int picWidth,
    DateTimeRange? timerange,
    LatLng? coordinates,
    String? context,
  }) = _BeaconEntity;

  const BeaconEntity._();

  String get imageUrl =>
      hasPicture
          ? '$kImageServer/$kImagesPath/${author.id}/$id.$kImageExt'
          : kImageServer + kBeaconPlaceholderUrl;
}
