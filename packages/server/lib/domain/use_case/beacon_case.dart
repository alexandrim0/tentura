import 'dart:async';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_root/domain/entity/coordinates.dart';
import 'package:tentura_root/domain/entity/date_range.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';

import 'image_case_mixin.dart';

@Injectable(order: 2)
class BeaconCase with ImageCaseMixin {
  const BeaconCase(this._beaconRepository, this._imageRepository);

  final BeaconRepository _beaconRepository;

  final ImageRepository _imageRepository;

  Future<BeaconEntity> create({
    required String userId,
    required String title,
    String? context,
    String? description,
    DateRange? dateRange,
    Stream<Uint8List>? imageBytes,
    Coordinates? coordinates,
  }) async {
    final beacon = await _beaconRepository.createBeacon(
      BeaconEntity.aNew(
        title: title,
        context: (context?.isEmpty ?? true) ? null : context,
        description: description ?? '',
        hasPicture: imageBytes != null,
        timerange: dateRange,
        coordinates: coordinates,
        author: UserEntity(id: userId),
      ),
    );
    if (imageBytes != null) {
      await _imageRepository.putBeaconImage(
        authorId: userId,
        beaconId: beacon.id,
        bytes: imageBytes,
      );
      unawaited(
        updateBlurHash(authorId: beacon.author.id, beaconId: beacon.id),
      );
    }
    return beacon;
  }

  Future<bool> deleteById({
    required String beaconId,
    required String userId,
  }) async {
    final beacon = await _beaconRepository.getBeaconById(
      beaconId: beaconId,
      filterByUserId: userId,
    );

    await _imageRepository.deleteBeaconImage(
      authorId: beacon.author.id,
      beaconId: beacon.id,
    );
    await _beaconRepository.deleteBeaconById(beacon.id);

    return true;
  }

  Future<void> updateBlurHash({
    required String authorId,
    required String beaconId,
  }) async {
    try {
      final imageBytes = await _imageRepository.getBeaconImage(
        authorId: authorId,
        beaconId: beaconId,
      );
      final image = decodeImage(imageBytes);
      await _beaconRepository.updateBeaconImageDetails(
        beaconId: beaconId,
        blurHash: calculateBlurHash(image),
        imageHeight: image.height,
        imageWidth: image.width,
      );
    } catch (e) {
      print(e);
    }
  }
}
