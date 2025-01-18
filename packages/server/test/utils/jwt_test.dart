import 'dart:convert';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';

import '../logger.dart';

void main() {
  group(
    'Read keys from PEM',
    () {
      const validPublicKey =
          'MCowBQYDK2VwAyEA2CmIb3Ho2eb6m8WIog6KiyzCY05sbyX04PiGlH5baDw=';
      const validPrivateKey =
          'MC4CAQAwBQYDK2VwBCIEIN3rCo3wCksyxX4qBYAC1vFr51kx/Od78QVrRLOV1orF';
      const envPublicKey =
          r'-----BEGIN PUBLIC KEY-----\nMCowBQYDK2VwAyEA2CmIb3Ho2eb6m8WIog6KiyzCY05sbyX04PiGlH5baDw=\n-----END PUBLIC KEY-----';
      const envPrivateKey =
          r'-----BEGIN PRIVATE KEY-----\nMC4CAQAwBQYDK2VwBCIEIN3rCo3wCksyxX4qBYAC1vFr51kx/Od78QVrRLOV1orF\n-----END PRIVATE KEY-----';

      test(
        'Read Public key from PEM',
        () {
          expect(
            parseKeyFromPEM(kJwtPublicKey),
            validPublicKey,
          );

          expect(
            parseKeyFromPEM(envPublicKey),
            validPublicKey,
          );

          expect(
            convertKey(parseKeyFromPEM(kJwtPublicKey)),
            isList,
          );

          expect(
            convertKey(parseKeyFromPEM(envPublicKey)),
            isList,
          );
        },
      );

      test(
        'Read Private key from const',
        () {
          expect(
            parseKeyFromPEM(kJwtPrivateKey),
            validPrivateKey,
          );

          expect(
            parseKeyFromPEM(envPrivateKey),
            validPrivateKey,
          );

          expect(
            convertKey(parseKeyFromPEM(kJwtPrivateKey)),
            isList,
          );

          expect(
            convertKey(parseKeyFromPEM(envPrivateKey)),
            isList,
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
