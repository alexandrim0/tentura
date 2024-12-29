import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../consts.dart';

export 'package:dart_jsonwebtoken/src/exceptions.dart';

///
/// Extract and convert a key from .pem
///
Uint8List convertKey(String key) {
  final bytes = base64Decode(key.split('\n')[1]);
  return bytes.sublist(bytes.length - 32);
}

///
/// Returns bearer token extracted from Request headers
///
String extractAuthToken({
  required Map<String, String> headers,
}) {
  final authHeader = headers['Authorization'];
  if (authHeader == null || authHeader.length <= _bearerPrefixLength) {
    throw JWTInvalidException('Wrong Authorization header');
  }

  final token = headers['Authorization']?.substring(_bearerPrefixLength).trim();
  if (token == null || token.isEmpty) {
    throw JWTInvalidException('Wrong Authorization header');
  }

  return token;
}

///
/// Returns parsed and verified client`s JWT with auth request
///
JWT verifyAuthRequest({
  required String token,
}) {
  final jwtDecoded = JWT.decode(token);

  if (jwtDecoded.header?['alg'] != 'EdDSA') {
    throw JWTInvalidException('Wrong JWT algo!');
  }

  return JWT.verify(
    token,
    EdDSAPublicKey(base64Decode((jwtDecoded.payload as Map)['pk'] as String)),
  );
}

///
/// Parse and verify JWT issued before
///
JWT verifyJwt({
  required String token,
}) =>
    JWT.verify(
      token,
      _publicKey,
    );

///
/// Create Oauth2 response
///
Map<String, Object> issueJwt({
  required String subject,
  Map<String, Object> payload = const {},
}) =>
    {
      'subject': subject,
      'token_type': 'bearer',
      'expires_in': kJwtExpiresIn.inSeconds,
      'access_token': JWT(
        payload,
        subject: subject,
      ).sign(
        _privateKey,
        algorithm: JWTAlgorithm.EdDSA,
        expiresIn: kJwtExpiresIn,
      ),
    };

const _bearerPrefixLength = 'Bearer '.length;

final _publicKeyBytes = convertKey(kJwtPublicKey);

final _publicKey = EdDSAPublicKey(_publicKeyBytes);

final _privateKey = EdDSAPrivateKey(
  convertKey(kJwtPrivateKey) + _publicKeyBytes,
);
