// ignore_for_file: avoid_print //

import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:tentura/env.dart';

@singleton
class FirebaseService {
  @FactoryMethod(preResolve: true)
  static Future<FirebaseService> initializeFirebase(Env env) async {
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

    FirebaseMessaging.instance.onTokenRefresh.listen(
      // ignore: unnecessary_lambdas //
      (fcmToken) {
        print('Refreshed FCM token: [$fcmToken]');
      },
      onError: print,
      cancelOnError: false,
    );

    await FirebaseMessaging.instance.requestPermission(
      provisional: true,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM token: [$fcmToken]');

    return FirebaseService(env);
  }

  FirebaseService(this._env);

  // ignore: unused_field //
  final Env _env;
}

class _FirebaseServiceFake implements FirebaseService {
  _FirebaseServiceFake(this._env);

  @override
  // ignore: unused_field //
  final Env _env;
}
