import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/image_repository.dart';

import '../entity/event_entity.dart';
import '../enum.dart';
import 'image_case_mixin.dart';

@Injectable(order: 2)
class BeaconCase with ImageCaseMixin {
  const BeaconCase(this._beaconRepository, this._imageRepository);

  final BeaconRepository _beaconRepository;

  final ImageRepository _imageRepository;

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
