import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/service/image_service.dart';
import 'package:tentura_server/domain/exception.dart';

import 'beacon_repository.dart';

@Injectable(
  as: BeaconRepository,
  env: [
    Environment.test,
  ],
  order: 1,
)
class BeaconRepositoryMock implements BeaconRepository {
  static final storageById = <String, BeaconEntity>{};

  BeaconRepositoryMock(
    this._imageService,
  );

  final ImageService _imageService;

  @override
  Future<BeaconEntity> createBeacon(BeaconEntity beacon) async =>
      storageById.containsKey(beacon.id)
          ? throw Exception('Key already exists [${beacon.id}]')
          : storageById[beacon.id] = beacon;

  @override
  Future<BeaconEntity> getBeaconById(String id) async =>
      storageById[id] ?? (throw IdNotFoundException(id));

  @override
  Future<void> setBeaconImage({
    required BeaconEntity beacon,
    required Uint8List imageBytes,
  }) async {
    final image = _imageService.decodeImage(imageBytes);
    final blurHash = _imageService.calculateBlurHash(image);
    storageById[beacon.id] = beacon.copyWith(
      blurHash: blurHash,
      hasPicture: true,
      picHeight: image.height,
      picWidth: image.width,
    );
  }
}
