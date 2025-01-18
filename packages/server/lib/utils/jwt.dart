import 'dart:convert';
import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/domain/exception.dart';

import '../consts.dart';

export 'package:dart_jsonwebtoken/src/exceptions.dart';

///
/// Parse key from PEM
///
String parseKeyFromPEM(String key) => key
    .replaceAll(r'\n', '\n')
    .replaceAll(RegExp('-(.*)-'), '')
    .replaceAll('\n', '');

///
/// Extract and convert a key from .pem
///
Uint8List convertKey(String key) {
  try {
    final bytes = base64Decode(parseKeyFromPEM(key));
    return bytes.sublist(bytes.length - 32);
  } catch (e) {
    GetIt.I<Logger>().f(
      'Wrong PEM file format!',
      error: e,
    );
    throw WrongPEMKeyException(e.toString());
  }
}

///
/// Returns bearer token extracted from Request headers
///
String extractAuthToken({
  required Map<String, String> headers,
}) {
  final authHeader = headers[kHeaderAuthorization];
  if (authHeader == null || authHeader.length <= _bearerPrefixLength) {
    throw JWTInvalidException('Wrong Authorization header');
  }

  final token = headers[kHeaderAuthorization]
      ?.substring(
        _bearerPrefixLength,
      )
      .trim();
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

  final authRequestToken = base64.normalize(
    (jwtDecoded.payload as Map)['pk'] as String,
  );

  return JWT.verify(
    token,
    EdDSAPublicKey(base64Decode(authRequestToken)),
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
