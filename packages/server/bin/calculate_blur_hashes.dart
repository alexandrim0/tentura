// ignore_for_file: avoid_print //

import 'dart:io';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/domain/enum.dart';
import 'package:tentura_server/data/model/beacon_model.dart';
import 'package:tentura_server/data/model/user_model.dart';
import 'package:tentura_server/data/service/image_service.dart';

Future<void> main(List<String> args) async {
  try {
    configureDependencies(Environment.prod);
  } catch (e) {
    print(e);
  }
  final imageService = getIt<ImageService>();
  final database = getIt<Database>();
  final beacons = <File>[];
  final users = <File>[];

  try {
    for (final f
        in Directory(
          kImageFolderPath,
        ).listSync(recursive: true).whereType<File>()) {
      f.uri.pathSegments.last == 'avatar.jpg' ? users.add(f) : beacons.add(f);
    }
  } catch (e) {
    print(e);
  }

  for (final u in users) {
    try {
      final id = u.uri.pathSegments[u.uri.pathSegments.length - 2];
      final image = imageService.decodeImage(await u.readAsBytes());
      final blurHash = imageService.calculateBlurHash(image);
      await database.users.updateOne(
        UserUpdateRequest(
          id: id,
          hasPicture: true,
          blurHash: blurHash,
          picHeight: image.height,
          picWidth: image.width,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  for (final b in beacons) {
    try {
      final beaconId = b.uri.pathSegments.last.split('.').first;
      final image = imageService.decodeImage(await b.readAsBytes());
      final blurHash = imageService.calculateBlurHash(image);
      await database.beacons.updateOne(
        BeaconUpdateRequest(
          id: beaconId,
          hasPicture: true,
          blurHash: blurHash,
          picHeight: image.height,
          picWidth: image.width,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  print(
    'users: [${users.length}], '
    'beacons: [${beacons.length}]',
  );
  await closeModules();
  exit(0);
}
