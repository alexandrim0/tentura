import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

JWT checkJWT(Map<String, String> headers) {
  final token = headers['Authorization']?.substring(7).trim() ?? '';
  if (token.isEmpty) throw Exception('Wrong JWT string');

  // TBD: read key from .env
  final jwt = JWT.verify(
    token,
    EdDSAPrivateKey([]),
  );
  return jwt;
}
