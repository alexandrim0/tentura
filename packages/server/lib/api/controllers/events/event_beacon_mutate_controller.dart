import 'package:minio/minio.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/api/helpers/remote_storage_helper.dart';
import 'package:tentura_server/data/model/beacon_model.dart';
import 'package:tentura_server/data/service/image_service.dart';

import '_event_controller.dart';

@Injectable(order: 3)
final class EventBeaconMutateController extends EventController
    with RemoteStorageHelper {
  const EventBeaconMutateController(
    this._database,
    this._imageService,
    this._remoteStorage,
  );

  final Database _database;

  final Minio _remoteStorage;

  final ImageService _imageService;

  Future<Response> handler(Request request) async {
    final data = getEventData(await request.body.asJson);

    switch (data.operation) {
      case Operation.delete:
        final beacon = data.oldEntity!;
        if (beacon['has_picture'] == true) {
          await _remoteStorage.removeObject(
            kS3Bucket,
            getBeaconObjectName(
              userId: beacon['user_id']! as String,
              beaconId: beacon['id']! as String,
            ),
          );
        }

      case Operation.insert:
      case Operation.manual:
        final beacon = data.newEntity!;
        if (beacon['has_picture'] != true) {
          return Response.ok(null);
        }
        final beaconId = beacon['id']! as String;
        final objectStream = await _remoteStorage.getObject(
          kS3Bucket,
          getBeaconObjectName(
            beaconId: beaconId,
            userId: beacon['user_id']! as String,
          ),
        );
        final image = _imageService.decodeImage(
          await readBodyAsBytes(() => objectStream),
        );
        await _database.beacons.updateOne(
          BeaconUpdateRequest(
            id: beaconId,
            hasPicture: true,
            picWidth: image.width,
            picHeight: image.height,
            blurHash: _imageService.calculateBlurHash(image),
          ),
        );

      case Operation.update:
    }

    return Response.ok(null);
  }
}
