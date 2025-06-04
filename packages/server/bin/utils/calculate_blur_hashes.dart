import 'dart:io';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/data/database/tentura_db.dart';
import 'package:tentura_server/domain/use_case/task_worker_case.dart';

class BlurHashCalculator {
  const BlurHashCalculator();

  Future<void> calculateBlurHashes() async {
    final getIt = await configureDependencies(Env.prod());
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
        final (:hash, :height, :width) = TaskWorkerCase.processImage(
          await u.readAsBytes(),
        );
        await database.managers.users
            .filter((f) => f.id.equals(id))
            .update(
              (o) => o(
                hasPicture: const Value(true),
                blurHash: Value(hash),
                picHeight: Value(height),
                picWidth: Value(width),
              ),
            );
      } catch (e) {
        print(e);
      }
    }

    for (final b in beacons) {
      try {
        final beaconId = b.uri.pathSegments.last.split('.').first;
        final (:hash, :height, :width) = TaskWorkerCase.processImage(
          await b.readAsBytes(),
        );
        await database.managers.beacons
            .filter((f) => f.id.equals(beaconId))
            .update(
              (o) => o(
                hasPicture: const Value(true),
                blurHash: Value(hash),
                picHeight: Value(height),
                picWidth: Value(width),
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
