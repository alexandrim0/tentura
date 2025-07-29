import 'dart:convert';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:tentura_server/env.dart';

@singleton
class FcmService {
  FcmService(this._env);

  final Env _env;

  late final _fcmEndpointUri = Uri.parse(
    'https://fcm.googleapis.com/v1/projects/${_env.fbProjectId}/messages:send',
  );

  Future<String>? _accessTokenFuture;

  //
  //
  Future<void> sendFcmMessage({
    required String accessToken,
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    try {
      final response = await post(
        _fcmEndpointUri,
        headers: {
          kHeaderContentType: kContentApplicationJson,
          kHeaderAuthorization: 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': fcmToken,
            'notification': {
              'title': title,
              'body': body,
            },
          },
        }),
      );
      if (response.statusCode != 200) {
        print(
          'Failed to send FCM message\n'
          'Response code: [${response.statusCode}, ${response.reasonPhrase}]\n'
          'Response body: ${response.body}',
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  ///
  /// Generates an OAuth2.0 access token for FCM.
  ///
  /// This method is concurrency-safe and ensures the token generation logic
  /// runs only once. The returned [Future] is cached. If token generation
  /// fails, the cache is cleared to allow for retries on subsequent calls.
  Future<String> generateAccessToken() =>
      _accessTokenFuture ??= _generateAndCacheAccessToken();

  //
  //
  Future<String> _generateAndCacheAccessToken() async {
    try {
      final response = await post(
        _oAuthTokenEndpointUri,
        headers: const {
          kHeaderContentType: kContentApplicationFormUrlencoded,
        },
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion':
              JWT(
                const {
                  'scope': 'https://www.googleapis.com/auth/firebase.messaging',
                },
                audience: Audience(['https://oauth2.googleapis.com/token']),
                issuer: _env.fbClientEmail,
              ).sign(
                _env.fbPrivateKey,
                algorithm: JWTAlgorithm.RS256,
                expiresIn: _env.fbAccessTokenExpiresIn,
              ),
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to obtain FCM access token\n'
          'Response code: [${response.statusCode}, ${response.reasonPhrase}]\n'
          'Response body: ${response.body}',
        );
      }

      final tokenInfo = json.decode(response.body) as Map<String, dynamic>;
      if (_env.isDebugModeOn) {
        print(tokenInfo);
      } else {
        print('FCM access token generated');
      }
      return tokenInfo['access_token']! as String;
    } catch (e) {
      _accessTokenFuture = null;
      print(e);
      rethrow;
    }
  }

  static final _oAuthTokenEndpointUri = Uri.parse(
    'https://oauth2.googleapis.com/token',
  );
}
