import 'dart:io';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/database/tentura_db.dart';
import 'package:tentura_server/domain/use_case/image_case_mixin.dart';

class BlurHashCalculator with ImageCaseMixin {
  const BlurHashCalculator();

  Future<void> calculateBlurHashes() async {
    final getIt = await configureDependencies(Environment.prod);
    final database = getIt<TenturaDb>();
    final beacons = <File>[];
    final users = <File>[];

    try {
      for (final f in Directory(
        kImagesPath,
      ).listSync(recursive: true).whereType<File>()) {
        f.uri.pathSegments.last == 'avatar.jpg' ? users.add(f) : beacons.add(f);
      }
    } catch (e) {
      print(e);
    }

    for (final u in users) {
      try {
        final id = u.uri.pathSegments[u.uri.pathSegments.length - 2];
        final image = decodeImage(await u.readAsBytes());
        final blurHash = calculateBlurHash(image);
        await database.managers.users
            .filter((f) => f.id.equals(id))
            .update(
              (o) => o(
                hasPicture: const Value(true),
                blurHash: Value(blurHash),
                picHeight: Value(image.height),
                picWidth: Value(image.width),
              ),
            );
      } catch (e) {
        print(e);
      }
    }

    for (final b in beacons) {
      try {
        final beaconId = b.uri.pathSegments.last.split('.').first;
        final image = decodeImage(await b.readAsBytes());
        final blurHash = calculateBlurHash(image);
        await database.managers.beacons
            .filter((f) => f.id.equals(beaconId))
            .update(
              (o) => o(
                hasPicture: const Value(true),
                blurHash: Value(blurHash),
                picHeight: Value(image.height),
                picWidth: Value(image.width),
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
    await getIt.reset();
  }
}
