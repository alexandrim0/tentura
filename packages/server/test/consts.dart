import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/consts.dart';

const kLocalhost = 'localhost';

const kIsIntegrationTest = bool.fromEnvironment('IS_INTEGRATION');

final kPublicKey = EdDSAPublicKey.fromPEM(
  kJwtPublicKey.replaceAll(r'\n', '\n'),
);

final kPrivateKey = EdDSAPrivateKey.fromPEM(
  kJwtPrivateKey.replaceAll(r'\n', '\n'),
);
