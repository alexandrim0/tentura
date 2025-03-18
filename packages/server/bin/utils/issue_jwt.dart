import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/consts.dart';

void issueJwt([String? userId]) {
  final kPrivateKey = EdDSAPrivateKey.fromPEM(
    kJwtPrivateKey.replaceAll(r'\n', '\n'),
  );
  print(
    JWT({'sub': userId ?? 'U3ea0a229ad85'}).sign(
      kPrivateKey,
      algorithm: JWTAlgorithm.EdDSA,
      expiresIn: const Duration(days: 365),
    ),
  );
}
