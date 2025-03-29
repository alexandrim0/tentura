import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_entity.freezed.dart';

@freezed
abstract class ImageEntity with _$ImageEntity {
  const factory ImageEntity({
    required Uint8List imageBytes,
    @Default('') String fileName,
    @Default('image/jpeg') String mimeType,
  }) = _ImageEntity;

  factory ImageEntity.empty() => ImageEntity(imageBytes: Uint8List(0));

  const ImageEntity._();

  bool get isEmpty => imageBytes.isEmpty;
}
