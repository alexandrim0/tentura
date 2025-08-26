import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:tentura/env.dart';

import '../../domain/entity/notification_permissions.dart';

@singleton
class FcmService {
  const FcmService(
    this._env,
    this._logger,
  );

  @factoryMethod
  factory FcmService.create({
    required Env env,
    required Logger logger,
  }) {
    if (env.firebaseApiKey.isEmpty) {
      logger.i('Firebase Messaging configured with fake service');
      return const _FcmServiceFake();
    }
    return FcmService(env, logger);
  }

  final Env _env;

  // ignore: unused_field //
  final Logger _logger;

  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  //
  //
  Future<NotificationPermissions> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      provisional: true,
    );
    return NotificationPermissions(
      authorized:
          settings.authorizationStatus == AuthorizationStatus.authorized,
    );
  }

  //
  //
  Future<String?> getToken() =>
      FirebaseMessaging.instance.getToken(vapidKey: _env.firebaseVapidKey);
}

class _FcmServiceFake implements FcmService {
  const _FcmServiceFake();

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Future<String?> getToken() => Future.value();

  @override
  Future<NotificationPermissions> requestPermission() => Future.value(
    const NotificationPermissions(),
  );

  @override
  // ignore: unused_element //
  Env get _env => throw UnimplementedError();

  @override
  // ignore: unused_element //
  Logger get _logger => throw UnimplementedError();
}
