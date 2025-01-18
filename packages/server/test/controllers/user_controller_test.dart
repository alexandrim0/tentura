import 'package:test/test.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';
import 'package:tentura_server/controllers/user/user_login_controller.dart';
import 'package:tentura_server/controllers/user/user_register_controller.dart';

import '../di.dart';
import '../consts.dart';
import '../logger.dart';

Future<void> main() async {
  final authRequestToken = _issueAuthRequestToken();

  setUp(() async {
    await configureDependencies();
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test(
    'routeUserRegister',
    () async {
      final response = await GetIt.I<UserRegisterController>().handler(
        Request(
          'POST',
          Uri.http(
            'localhost',
            '/api/user/register',
          ),
          headers: {
            kHeaderAuthorization: 'Bearer $authRequestToken',
          },
        ),
      );
      final responseBody = await response.readAsString();
      logger.i(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );

  test(
    'routeUserLogin',
    () async {
      final response = await GetIt.I<UserLoginController>().handler(
        Request(
          'POST',
          Uri.http(
            'localhost',
            '/api/user/login',
          ),
          headers: {
            kHeaderAuthorization: 'Bearer $authRequestToken',
          },
        ),
      );
      final responseBody = await response.readAsString();
      logger.i(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );

  test(
    'routeUserLogin, with static request',
    () async {
      const authRequestToken =
          'eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJwayI6IjFVTUJueGd4ZVJCTDQwMzcyMTlfMzVDUHZSYlBtc1AyUVUxUlVSeXRpaHciLCJleHAiOjE3MzcyMTU2MTcsImlhdCI6MTczNzIxMjAxN30.A4rU-BoK-mtswY1aSCeWpldHlySGok_DR_sUDAHvOeemQPvDQ6mYCuFG1bb5A-fP7dYGdvyh0-wnIkLDQdgFCg';

      final response = await GetIt.I<UserLoginController>().handler(
        Request(
          'POST',
          Uri.http(
            'localhost',
            '/api/user/login',
          ),
          headers: {
            kHeaderAuthorization: 'Bearer $authRequestToken',
          },
        ),
      );
      final responseBody = await response.readAsString();
      logger.i(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );
}

String _issueAuthRequestToken([String? userId]) => issueJwt(
      subject: userId ?? generateId(),
      payload: {
        'pk': publicKey,
      },
    )['access_token']! as String;
