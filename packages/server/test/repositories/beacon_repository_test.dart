import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/utils/id.dart';

import '../di.dart';
import '../consts.dart';
import '../logger.dart';

Future<void> main() async {
  final faker = Faker();

  setUp(() async {
    await configureDependencies();
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test(
    'createBeacon',
    () async {
      final now = DateTime.timestamp();
      final user =
          await GetIt.I<UserRepository>().getUserByPublicKey(publicKey);
      final beacon =
          await GetIt.I<BeaconRepository>().createBeacon(BeaconEntity(
        id: generateId(prefix: 'B'),
        title: faker.lorem.sentence(),
        description:
            faker.lorem.sentences(faker.randomGenerator.integer(5)).join(),
        createdAt: now,
        updatedAt: now,
        author: user,
      ));
      logger.i([
        beacon.id,
        beacon.title,
        beacon.description,
      ].join(' | '));

      expect(beacon.id, isNotEmpty);
    },
  );
}
