import 'package:shelf_plus/shelf_plus.dart';

import 'route_chat.dart';
import 'route_shared_view.dart';
import 'route_user_login.dart';
import 'route_user_register.dart';

Handler routeHandler() {
  final router = Router().plus
    ..use(logRequests())
    ..get(
      '/health',
      () => 'I`m fine!',
    )
    ..get(
      '/shared/view',
      routeSharedView,
    )
    ..get(
      '/chat',
      routeChat,
    )
    ..post(
      '/api/user/login',
      routeUserLogin,
    )
    ..post(
      '/api/user/register',
      routeUserRegister,
    );

  return router.call;
}
