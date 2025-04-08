import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_root/domain/entity/coordinates.dart';
import 'package:tentura_root/domain/entity/date_range.dart';
import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';

import 'user_entity.dart';

part 'beacon_entity.freezed.dart';

@freezed
abstract class BeaconEntity with _$BeaconEntity {
  static String get newId => generateId('B');

  const factory BeaconEntity({
    required String id,
    required String title,
    required UserEntity author,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isEnabled,
    @Default(false) bool hasPicture,
    @Default('') String description,
    @Default('') String blurHash,
    @Default(0) int picHeight,
    @Default(0) int picWidth,
    DateRange? timerange,
    Coordinates? coordinates,
    String? context,
  }) = _BeaconEntity;

  factory BeaconEntity.aNew({
    required String title,
    required UserEntity author,
    bool hasPicture = false,
    String description = '',
    DateRange? timerange,
    Coordinates? coordinates,
    String? context,
  }) {
    final now = DateTime.timestamp();
    return BeaconEntity(
      id: newId,
      title: title,
      author: author,
      createdAt: now,
      updatedAt: now,
      context: context,
      timerange: timerange,
      coordinates: coordinates,
      description: description,
      hasPicture: hasPicture,
    );
  }

  const BeaconEntity._();

  String get imageUrl =>
      hasPicture
          ? '$kImageServer/$kImagesPath/${author.id}/$id.$kImageExt'
          : kImageServer + kBeaconPlaceholderUrl;

  Map<String, Object> get asJson => {'id': id};
}
