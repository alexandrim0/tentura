import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:blurhash_dart/blurhash_dart.dart';

mixin ImageCaseMixin {
  static const kMaxNumCompX = 8;
  static const kMinNumCompX = 6;

  img.Image decodeImage(Uint8List imageBytes) =>
      img.decodeImage(imageBytes) ??
      (throw const FormatException('Cant decode image'));

  String calculateBlurHash(img.Image image) {
    final numComp =
        image.height == image.width
            ? (x: kMaxNumCompX, y: kMaxNumCompX)
            : image.height > image.width
            ? (x: kMinNumCompX, y: kMaxNumCompX)
            : (x: kMaxNumCompX, y: kMinNumCompX);
    return BlurHash.encode(
      image,
      numCompX: numComp.x,
      numCompY: numComp.y,
    ).hash;
  }
}
