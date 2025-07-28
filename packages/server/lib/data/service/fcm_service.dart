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

  //
  //
  Future<void> sendFcmMessages({
    required String accessToken,
    required Iterable<String> fcmTokens,
    required String title,
    required String body,
  }) => Future.wait<void>(
    fcmTokens.map(
      (fcmToken) => sendFcmMessage(
        accessToken: accessToken,
        fcmToken: fcmToken,
        title: title,
        body: body,
      ),
    ),
  );

  //
  //
  Future<String> generateAccessToken() async {
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
      print(tokenInfo);
      return tokenInfo['access_token']! as String;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static final _oAuthTokenEndpointUri = Uri.parse(
    'https://oauth2.googleapis.com/token',
  );
}
