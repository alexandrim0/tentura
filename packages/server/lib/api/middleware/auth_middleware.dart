import 'dart:convert';
import 'dart:developer';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/consts.dart';

@Injectable(
  order: 2,
)
class AuthMiddleware {
  @visibleForTesting
  final publicKey = EdDSAPublicKey.fromPEM(
    kJwtPublicKey.replaceAll(r'\n', '\n'),
  );

  @visibleForTesting
  final privateKey = EdDSAPrivateKey.fromPEM(
    kJwtPrivateKey.replaceAll(r'\n', '\n'),
  );

  ///
  /// Extract and verify bearer token.
  /// If ok, save it in request.context[kContextUserId]
  ///
  Middleware get extractBearer => createMiddleware(
        requestHandler: (Request request) {
          if (request.headers.containsKey(kHeaderAuthorization)) {
            try {
              request.context[kContextUserId] = verifyAuthRequest(
                extractAuthTokenFromHeaders(request.headers),
              ).subject!;
            } catch (e) {
              final error = e.toString();
              log(error);
              return Response.unauthorized(error);
            }
          }
          return null;
        },
      );

  ///
  /// Return code 401 if no userId in context
  ///
  Middleware get demandAuth => createMiddleware(
        requestHandler: (Request request) =>
            request.context.containsKey(kContextUserId)
                ? null
                : Response.unauthorized(null),
      );

  ///
  /// Returns bearer token extracted from Request headers
  ///
  @visibleForTesting
  String extractAuthTokenFromHeaders(Map<String, String> headers) {
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
  @visibleForTesting
  JWT verifyAuthRequest(String token) {
    final jwtDecoded = JWT.decode(token);

    if (jwtDecoded.header?['alg'] != 'EdDSA') {
      throw JWTInvalidException('Wrong JWT algo!');
    }

    final exp = (jwtDecoded.payload as Map)['exp'];
    final expiresIn = exp is int ? exp * 1000 : 0;

    if (expiresIn <= 0 || expiresIn > kAuthJwtExpiresIn) {
      throw JWTInvalidException('Wrong JWT exp value!');
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
  @visibleForTesting
  JWT verifyJwt(String token) => JWT.verify(
        token,
        publicKey,
      );

  ///
  /// Create Oauth2 response
  ///
  @visibleForTesting
  Map<String, Object> issueJwt({
    required String subject,
    Map<String, Object> payload = const {},
  }) =>
      {
        'subject': subject,
        'token_type': 'bearer',
        'expires_in': kJwtExpiresIn,
        'access_token': JWT(
          payload,
          subject: subject,
        ).sign(
          privateKey,
          algorithm: JWTAlgorithm.EdDSA,
          expiresIn: const Duration(seconds: kJwtExpiresIn),
        ),
      };

  static const _bearerPrefixLength = 'Bearer '.length;
}
