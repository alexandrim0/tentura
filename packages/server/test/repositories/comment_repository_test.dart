import 'dart:convert';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura_server/data/repository/comment_repository.dart';
import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';

import '../di.dart';
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
    'createComment',
    () async {
      final now = DateTime.timestamp();
      final user = await GetIt.I<UserRepository>().createUser(
        publicKey: base64UrlEncode(publicKey.key.bytes).replaceAll('=', ''),
        user: UserEntity(
          id: generateId(),
          title: 'Test User',
        ),
      );
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
      final comment =
          await GetIt.I<CommentRepository>().createComment(CommentEntity(
        id: generateId(prefix: 'C'),
        author: user,
        beacon: beacon,
        createdAt: now,
        content: faker.lorem.sentences(faker.randomGenerator.integer(5)).join(),
      ));
      logger.i([
        comment.id,
        comment.content,
      ].join(' | '));

      expect(
        await GetIt.I<CommentRepository>().getCommentById(comment.id),
        comment,
      );
    },
  );
}
