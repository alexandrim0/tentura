import 'package:test/test.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:injectable/injectable.dart' show Environment;

import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/consts.dart';
import 'package:tentura_server/controllers/user/user_login_controller.dart';
import 'package:tentura_server/controllers/user/user_register_controller.dart';

import '../_utils/user_utils.dart';
import '../logger.dart';

Future<void> main() async {
  const isIntegrationTest = bool.fromEnvironment(
    'IS_INTEGRATION',
  );

  final authRequestToken = issueAuthRequestToken();

  setUp(() async {
    await configureDependencies(
      isIntegrationTest ? Environment.dev : Environment.test,
    );
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
}
