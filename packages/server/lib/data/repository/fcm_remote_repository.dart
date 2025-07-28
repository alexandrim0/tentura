import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';

import '../service/fcm_service.dart';

@Singleton(
  env: [
    Environment.dev,
    Environment.prod,
  ],
  order: 1,
)
///
/// A repository for sending Firebase Cloud Messaging (FCM) push notifications.
///
/// This repository manages the FCM access token, automatically refreshing it
/// when it expires before sending a message.
///
class FcmRemoteRepository {
  FcmRemoteRepository(
    this._env,
    this._fcmService,
  );

  final Env _env;

  final FcmService _fcmService;

  ({DateTime expiresAt, String accessToken}) _credentials = (
    expiresAt: DateTime.fromMillisecondsSinceEpoch(0),
    accessToken: '',
  );

  ///
  /// Sends a push notification via FCM to a specific device.
  ///
  Future<void> sendFcmMessage({
    required String fcmToken,
    required String title,
    required String body,
  }) async => _fcmService.sendFcmMessage(
    accessToken: await _getAccessToken(),
    fcmToken: fcmToken,
    title: title,
    body: body,
  );

  ///
  /// Sends a push notification via FCM to a list of devices.
  ///
  Future<void> sendFcmMessages({
    required Iterable<String> fcmTokens,
    required String title,
    required String body,
  }) async {
    if (fcmTokens.isNotEmpty) {
      return _fcmService.sendFcmMessages(
        accessToken: await _getAccessToken(),
        fcmTokens: fcmTokens,
        title: title,
        body: body,
      );
    }
  }

  //
  //
  Future<String> _getAccessToken() async {
    final now = DateTime.timestamp();
    if (_credentials.expiresAt.isBefore(now)) {
      final timeLag = _env.fbAccessTokenExpiresIn.inSeconds ~/ 100;
      _credentials = (
        expiresAt: now.add(
          _env.fbAccessTokenExpiresIn - Duration(seconds: timeLag),
        ),
        accessToken: await _fcmService.generateAccessToken(),
      );
    }
    return _credentials.accessToken;
  }
}
