import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';
import 'dart:async';

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

  late final _timeLag = _env.fbAccessTokenExpiresIn.inSeconds ~/ 100;

  ({DateTime expiresAt, String accessToken}) _credentials = (
    expiresAt: DateTime.fromMillisecondsSinceEpoch(0),
    accessToken: '',
  );

  Completer<String>? _tokenCompleter;

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
      final accessToken = await _getAccessToken();
      await Future.wait(
        fcmTokens.map(
          (fcmToken) => _fcmService.sendFcmMessage(
            accessToken: accessToken,
            fcmToken: fcmToken,
            title: title,
            body: body,
          ),
        ),
      );
    }
  }

  //
  //
  Future<String> _getAccessToken() async {
    final now = DateTime.timestamp();

    if (_credentials.expiresAt.isAfter(now)) {
      return _credentials.accessToken;
    }

    if (_tokenCompleter != null) {
      return _tokenCompleter!.future;
    }

    _tokenCompleter = Completer<String>();
    final expiresIn = _env.fbAccessTokenExpiresIn - Duration(seconds: _timeLag);
    try {
      final accessToken = await _fcmService.generateAccessToken();
      _credentials = (
        accessToken: accessToken,
        expiresAt: now.add(expiresIn),
      );
      _tokenCompleter?.complete(accessToken);
      return accessToken;
    } catch (e) {
      _tokenCompleter?.completeError(e);
      rethrow;
    } finally {
      _tokenCompleter = null;
    }
  }
}
