import 'dart:io';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/model/beacon_model.dart';
import 'package:tentura_server/data/service/image_service.dart';
import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/exception.dart';

export 'package:tentura_server/domain/entity/beacon_entity.dart';

@Injectable(
  env: [
    Environment.dev,
    Environment.prod,
  ],
  order: 1,
)
class BeaconRepository {
  BeaconRepository(
    this._database,
    this._imageService,
  );

  final Database _database;

  final ImageService _imageService;

  Future<BeaconEntity> createBeacon(BeaconEntity beacon) async {
    await _database.beacons.insertOne(BeaconInsertRequest(
      id: beacon.id,
      userId: beacon.author.id,
      title: beacon.title,
      description: beacon.description,
      hasPicture: beacon.hasPicture,
      picHeight: beacon.picHeight,
      picWidth: beacon.picWidth,
      blurHash: beacon.blurHash,
      createdAt: beacon.createdAt,
      updatedAt: beacon.updatedAt,
      enabled: beacon.isEnabled,
      timerange: beacon.timerange,
      context: beacon.context,
      lat: beacon.coordinates?.latitude,
      long: beacon.coordinates?.longitude,
    ));
    return getBeaconById(beacon.id);
  }

  Future<BeaconEntity> getBeaconById(String id) async =>
      switch (await _database.beacons.queryBeacon(id)) {
        final BeaconModel m => m.asEntity,
        null => throw IdNotFoundException(id),
      };

  Future<void> setBeaconImage({
    required BeaconEntity beacon,
    required Uint8List imageBytes,
  }) async {
    final image = _imageService.decodeImage(imageBytes);
    final file = File(
      '$kImageFolderPath/${beacon.author.id}/${beacon.id}.$kImageExt',
    );
    if (file.existsSync()) {
      throw Exception('File already exists!');
    }
    await _imageService.saveBytesToFile(
      imageBytes,
      file,
    );
    final blurHash = _imageService.calculateBlurHash(image);
    await _database.beacons.updateOne(BeaconUpdateRequest(
      id: beacon.id,
      hasPicture: true,
      blurHash: blurHash,
      picHeight: image.height,
      picWidth: image.width,
    ));
  }
}
