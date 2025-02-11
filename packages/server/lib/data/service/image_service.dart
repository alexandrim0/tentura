import 'dart:io';
import 'dart:developer';
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

  Future<void> saveBytesToFile(
    Uint8List imageBytes,
    File file,
  ) async {
    IOSink? sink;
    try {
      file.parent.createSync(recursive: true);
      sink = file.openWrite()..add(imageBytes);
      await sink.flush();
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      await sink?.close();
    }
  }

  Future<void> saveStreamToFile(
    Stream<List<int>> stream,
    File file,
  ) async {
    IOSink? sink;
    try {
      file.parent.createSync(recursive: true);
      sink = file.openWrite();
      await sink.addStream(stream);
      await sink.flush();
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      await sink?.close();
    }
  }

  String calculateBlurHash(Image image) => BlurHash.encode(
        image,
        numCompX: kBlurHashX,
        numCompY: kBlurHashY,
      ).hash;
}
