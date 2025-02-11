import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blurhash_dart/blurhash_dart.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/image_entity.dart';

@injectable
class ImageRepository {
  ImageRepository(
    this._remoteApiService,
  );

  final RemoteApiService _remoteApiService;

  Future<ImageEntity?> pickImage() async {
    final maxDimension = kImageMaxDimension.toDouble();
    final xFile = await _imagePicker.pickImage(
      maxHeight: maxDimension,
      maxWidth: maxDimension,
      source: ImageSource.gallery,
    );
    if (xFile == null) return null;

    final image = decodeImage(await xFile.readAsBytes());

    if (image == null || image.isEmpty || !image.isValid) {
      throw const FormatException('Unsupported image format!');
    }

    final numComp = image.height == image.width
        ? (x: kMaxNumCompX, y: kMaxNumCompX)
        : image.height > image.width
            ? (x: kMinNumCompX, y: kMaxNumCompX)
            : (x: kMaxNumCompX, y: kMinNumCompX);
    final blurHash = BlurHash.encode(
      image,
      numCompX: numComp.x,
      numCompY: numComp.y,
    ).hash;
    final resultImage = encodeJpg(
      image,
      quality: kImageQuality,
    );
    return ImageEntity(
      imageBytes: resultImage,
      fileName: xFile.name,
      blurHash: blurHash,
      height: image.height,
      width: image.width,
    );
  }

  Future<void> putBeaconImage({
    required Uint8List image,
    required String beaconId,
  }) async {
    await _remoteApiService.uploadImage(
      image: image,
      id: beaconId,
    );
    // Wait to be sure image is saved and available via web
    // TBD: replace with Image.network which can retry
    await Future<void>.delayed(const Duration(
      milliseconds: 250,
    ));
  }

  static final _imagePicker = ImagePicker();
}
