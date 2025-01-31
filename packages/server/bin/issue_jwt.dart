import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/utils/jwt.dart';

void main(List<String> args) {
  final jwt = JWT({
    'sub': 'U3ea0a229ad85',
  }).sign(
    privateKey,
    algorithm: JWTAlgorithm.EdDSA,
    expiresIn: const Duration(days: 365),
  );
  // ignore: avoid_print //
  print(jwt);
}
