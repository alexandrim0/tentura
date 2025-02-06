import 'dart:io';
import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/model/beacon_model.dart';
import 'package:tentura_server/data/model/user_model.dart';
import 'package:tentura_server/data/service/image_service.dart';

@Injectable(
  order: 3,
)
final class ActionBlurHashController {
  ActionBlurHashController(
    this._database,
    this._imageService,
  );

  final Database _database;

  final ImageService _imageService;

  Future<Response> handler(Request request) async {
    final users = <File>[];
    final beacons = <File>[];
    try {
      for (final f in Directory(kImageFolderPath)
          .listSync(recursive: true)
          .whereType<File>()) {
        f.uri.pathSegments.last == 'avatar.jpg' ? users.add(f) : beacons.add(f);
      }
    } catch (e) {
      log(e.toString());
    }

    for (final u in users) {
      try {
        final id = u.uri.pathSegments[u.uri.pathSegments.length - 2];
        final image = _imageService.decodeImage(await u.readAsBytes());
        final blurHash = _imageService.calculateBlurHash(image);
        await _database.users.updateOne(UserUpdateRequest(
          id: id,
          hasPicture: true,
          blurHash: blurHash,
          picHeight: image.height,
          picWidth: image.width,
        ));
      } catch (e) {
        log(e.toString());
      }
    }

    for (final b in beacons) {
      try {
        final beaconId = b.uri.pathSegments.last.split('.').first;
        final image = _imageService.decodeImage(await b.readAsBytes());
        final blurHash = _imageService.calculateBlurHash(image);
        await _database.beacons.updateOne(BeaconUpdateRequest(
          id: beaconId,
          hasPicture: true,
          blurHash: blurHash,
          picHeight: image.height,
          picWidth: image.width,
        ));
      } catch (e) {
        log(e.toString());
      }
    }

    return Response.ok(
      'users: [${users.length}], '
      'beacons: [${beacons.length}]',
      headers: {
        'Content-Type': 'text/text',
      },
    );
  }
}
