import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:tentura/env.dart';

@singleton
class FirebaseService {
  @FactoryMethod(preResolve: true)
  static Future<FirebaseService> create({
    required Env env,
    required Logger logger,
  }) async {
    if (env.firebaseApiKey.isNotEmpty) {
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
    }
    return FirebaseService();
  }
}
