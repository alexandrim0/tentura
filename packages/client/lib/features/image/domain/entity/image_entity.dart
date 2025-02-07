import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_entity.freezed.dart';

@freezed
class ImageEntity with _$ImageEntity {
  const factory ImageEntity({
    required Uint8List imageBytes,
    @Default('') String blurHash,
    @Default(0) int height,
    @Default(0) int width,
  }) = _ImageEntity;
}
