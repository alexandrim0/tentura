import 'dart:convert';
import 'dart:developer';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/domain/enum.dart';
import 'package:tentura_server/data/repository/beacon_repository_mock.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';

import '../consts.dart';
import '../data.dart';

Future<void> main() async {
  final faker = Faker();

  setUp(() {
    configureDependencies(
      kIsIntegrationTest ? Environment.dev : Environment.test,
    );
    BeaconRepositoryMock.storageById.addAll(kBeaconById);
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('createBeacon', () async {
    final now = DateTime.timestamp();
    final user = await getIt<UserRepository>().createUser(
      publicKey: base64UrlEncode(publicKey.key.bytes).replaceAll('=', ''),
      user: UserEntity(id: generateId(), title: 'Test User'),
    );
    final beacon = await getIt<BeaconRepository>().createBeacon(
      BeaconEntity(
        id: generateId(prefix: 'B'),
        title: faker.lorem.sentence(),
        description:
            faker.lorem.sentences(faker.randomGenerator.integer(5)).join(),
        createdAt: now,
        updatedAt: now,
        author: user,
      ),
    );
    log([beacon.id, beacon.title, beacon.description].join(' | '));

    expect(
      await getIt<BeaconRepository>().getBeaconById(beaconId: beacon.id),
      beacon,
    );
  });
}
