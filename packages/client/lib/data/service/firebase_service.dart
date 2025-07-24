import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:tentura/env.dart';

@singleton
class FirebaseService {
  @FactoryMethod(preResolve: true)
  static Future<FirebaseService> create({
    required Env env,
    required Logger logger,
  }) async {
    if (env.firebaseApiKey.isEmpty) {
      logger.i('Firebase configured with fake service');
      return _FirebaseServiceFake();
    }

    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: env.firebaseAppId,
        apiKey: env.firebaseApiKey,
        projectId: env.firebaseProjectId,
        authDomain: env.firebaseAuthDomain,
        storageBucket: env.firebaseStorageBucket,
        messagingSenderId: env.firebaseMessagingSenderId,
      ),
    );

    return FirebaseService();
  }

  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  Future<void> requestPermission() =>
      FirebaseMessaging.instance.requestPermission(
        provisional: true,
      );

  Future<String?> getToken() => FirebaseMessaging.instance.getToken();
}

class _FirebaseServiceFake implements FirebaseService {
  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Future<String?> getToken() => Future.value();

  @override
  Future<void> requestPermission() => Future.value();
}
