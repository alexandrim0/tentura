import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:injectable/injectable.dart';
import 'package:blurhash_dart/blurhash_dart.dart';

import 'package:tentura_server/consts.dart';

@injectable
class ImageService {
  const ImageService();

  Image decodeImage(Uint8List imageBytes) =>
      decodeJpg(imageBytes) ?? (throw Exception('Can`t decode jpeg'));

  String calculateBlurHash(Image image) =>
      BlurHash.encode(image, numCompX: kBlurHashX, numCompY: kBlurHashY).hash;
}
