import 'dart:convert';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';

import '../logger.dart';

void main() {
  group(
    'Read keys from PEM',
    () {
      const envPublicKey =
          r'-----BEGIN PUBLIC KEY-----\nMCowBQYDK2VwAyEA2CmIb3Ho2eb6m8WIog6KiyzCY05sbyX04PiGlH5baDw=\n-----END PUBLIC KEY-----';
      const envPrivateKey =
          r'-----BEGIN PRIVATE KEY-----\nMC4CAQAwBQYDK2VwBCIEIN3rCo3wCksyxX4qBYAC1vFr51kx/Od78QVrRLOV1orF\n-----END PRIVATE KEY-----';

      test(
        'Read PEM',
        () {
          expect(
            EdDSAPublicKey.fromPEM(kJwtPublicKey).key.bytes,
            isNotEmpty,
          );

          expect(
            EdDSAPrivateKey.fromPEM(kJwtPrivateKey).key.bytes,
            isNotEmpty,
          );

          expect(
            EdDSAPublicKey.fromPEM(envPublicKey.replaceAll(r'\n', '\n'))
                .key
                .bytes,
            isNotEmpty,
          );

          expect(
            EdDSAPrivateKey.fromPEM(envPrivateKey.replaceAll(r'\n', '\n'))
                .key
                .bytes,
            isNotEmpty,
          );
        },
      );
    },
  );

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
              headers: {kHeaderAuthorization: 'Bearer   $jwt  '},
            ),
            equals(jwt),
          );

          expect(
            () => extractAuthToken(
              headers: {kHeaderAuthorization: 'Bearer'},
            ),
            throwsA(isA<JWTInvalidException>()),
          );
        },
      );

      test(
        'issueJwt / verifyAuthRequest',
        () {
          final userId = generateId();
          final pk = base64UrlEncode(publicKey.key.bytes);
          final authRequestToken = issueJwt(
            subject: userId,
            payload: {
              'pk': pk,
            },
          )['access_token']! as String;

          final jwt = verifyAuthRequest(token: authRequestToken);
          logger.i(jwt.payload);

          expect(
            (jwt.payload as Map)['pk'],
            equals(pk),
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
