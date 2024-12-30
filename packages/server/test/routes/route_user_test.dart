import 'package:test/test.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/di/di.dart';
import 'package:tentura_server/consts.dart';
import 'package:tentura_server/routes/route_user_login.dart';
import 'package:tentura_server/routes/route_user_register.dart';

import '../logger.dart';
import 'user_utils.dart';

Future<void> main() async {
  final authRequestToken = issueAuthRequestToken();

  setUp(() async {
    await configureDependencies();
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test(
    'routeUserRegister',
    () async {
      final response = await routeUserRegister(Request(
        'POST',
        Uri.http(
          'localhost',
          '/api/user/register',
        ),
        headers: {
          kHeaderAuthorization: 'Bearer $authRequestToken',
        },
      ));
      final responseBody = await response.readAsString();
      logger.i(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );

  test(
    'routeUserLogin',
    () async {
      final response = await routeUserLogin(Request(
        'POST',
        Uri.http(
          'localhost',
          '/api/user/login',
        ),
        headers: {
          kHeaderAuthorization: 'Bearer $authRequestToken',
        },
      ));
      final responseBody = await response.readAsString();
      logger.i(responseBody);

      expect(responseBody, isNotEmpty);
    },
  );
}
