import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:tentura/env.dart';

@singleton
class FirebaseService {
  @FactoryMethod(preResolve: true)
  static Future<FirebaseService> create(Env env) async {
    if (env.firebaseApiKey.isEmpty) {
      return _FirebaseServiceFake(env);
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

    return FirebaseService(env);
  }

  FirebaseService(this._env);

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  Future<void> requestPermission() => _firebaseMessaging.requestPermission(
    provisional: true,
  );

  Future<String?> getToken() => _firebaseMessaging.getToken();

  // ignore: unused_field //
  final Env _env;

  static final _firebaseMessaging = FirebaseMessaging.instance;
}

class _FirebaseServiceFake implements FirebaseService {
  _FirebaseServiceFake(this._env);

  @override
  // ignore: unused_field //
  final Env _env;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Future<String?> getToken() => Future.value();

  @override
  Future<void> requestPermission() => Future.value();
}
