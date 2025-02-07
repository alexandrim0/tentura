import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blurhash_dart/blurhash_dart.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/data/service/remote_api_service.dart';

import '../../domain/entity/image_entity.dart';
import '../../domain/enum.dart';

@injectable
class ImageRepository {
  ImageRepository(
    this._remoteApiService,
  );

  final RemoteApiService _remoteApiService;

  Future<ImageEntity?> pickImage({
    required ImageType imageType,
  }) async {
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
    final xy = switch (imageType) {
      ImageType.avatar => (3, 3),
      ImageType.beacon => (5, 5),
    };
    final blurHash = BlurHash.encode(
      image,
      numCompX: xy.$1,
      numCompY: xy.$2,
    ).hash;
    final resultImage = encodeJpg(
      image,
      quality: kImageQuality,
    );
    return ImageEntity(
      imageBytes: resultImage,
      blurHash: blurHash,
      height: image.height,
      width: image.width,
    );
  }

  Future<void> putBeaconImage({
    required Uint8List image,
    required String beaconId,
  }) =>
      _remoteApiService.uploadImage(
        image: image,
        id: beaconId,
      );

  static final _imagePicker = ImagePicker();
}
