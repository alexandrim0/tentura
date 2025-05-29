import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/env.dart';

void issueJwt([String? userId]) {
  print(
    JWT({'sub': userId ?? 'U3ea0a229ad85'}).sign(
      Env.fromSystem().privateKey,
      algorithm: JWTAlgorithm.EdDSA,
      expiresIn: const Duration(days: 365),
    ),
  );
}
