import 'dart:typed_data';
import 'package:latlong2/latlong.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_root/domain/entity/date_time_range.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';

import '../entity/event_entity.dart';
import '../enum.dart';
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
    Stream<Uint8List>? imageBytes,
    ({double lat, double long})? coordinates,
    ({DateTime? from, DateTime? to})? timeRange,
  }) async {
    final beacon = await _beaconRepository.createBeacon(
      BeaconEntity.aNew(
        title: title,
        context: context,
        description: description ?? '',
        hasPicture: imageBytes != null,
        timerange:
            timeRange == null
                ? null
                : DateTimeRange(start: timeRange.from, end: timeRange.to),
        coordinates:
            coordinates == null
                ? null
                : LatLng(coordinates.lat, coordinates.long),
        author: UserEntity(id: userId),
      ),
    );
    if (imageBytes != null) {
      await _imageRepository.putBeaconImage(
        authorId: userId,
        beaconId: beacon.id,
        bytes: imageBytes,
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

  Future<void> handleEvent(EventEntity event) async {
    switch (event.operation) {
      case HasuraOperation.insert:
      case HasuraOperation.manual:
        final beacon = event.newData!;
        if (beacon['has_picture'] == true && beacon['blur_hash'] == '') {
          final beaconId = beacon['id']! as String;
          final image = decodeImage(
            await _imageRepository.getBeaconImage(
              authorId: beacon['user_id']! as String,
              beaconId: beaconId,
            ),
          );
          await _beaconRepository.updateBeaconImageDetails(
            beaconId: beaconId,
            blurHash: calculateBlurHash(image),
            imageHeight: image.height,
            imageWidth: image.width,
          );
        }

      case HasuraOperation.delete:
      case HasuraOperation.update:
    }
  }
}
