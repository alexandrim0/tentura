import 'dart:convert';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';

import '../logger.dart';

void main() {
  group(
    'Test of JWT utils',
    () {
      test(
        'extractAuthToken',
        () {
          final jwt = faker.jwt.valid();
          logger.i('[$jwt]');

          expect(
            extractAuthToken(
              headers: {'Authorization': 'Bearer   $jwt  '},
            ),
            equals(jwt),
          );

          expect(
            () => extractAuthToken(
              headers: {'Authorization': 'Bearer'},
            ),
            throwsA(isA<JWTInvalidException>()),
          );
        },
      );

      test(
        'issueJwt / verifyAuthRequest',
        () {
          final userId = generateId();
          final publicKey = base64UrlEncode(convertKey(kJwtPublicKey));
          final authRequestToken = issueJwt(
            subject: userId,
            payload: {
              'pk': publicKey,
            },
          )['access_token']! as String;

          final jwt = verifyAuthRequest(token: authRequestToken);
          logger.i(jwt.payload);

          expect(
            (jwt.payload as Map)['pk'],
            equals(publicKey),
          );

          expect(
            jwt.subject,
            equals(userId),
          );
        },
      );

      test(
        'issueJwt / verifyJwt',
        () {
          final userId = generateId();
          final authRequestToken = issueJwt(
            subject: userId,
          )['access_token']! as String;

          final jwt = verifyJwt(token: authRequestToken);
          logger.i(jwt.payload);

          expect(
            jwt.subject,
            equals(userId),
          );
        },
      );
    },
  );
}
