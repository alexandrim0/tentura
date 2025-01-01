import 'package:shelf_plus/shelf_plus.dart';

import 'controllers/chat_controller.dart';
import 'controllers/shared_view_controller.dart';
import 'controllers/user_login_controller.dart';
import 'controllers/user_register_controller.dart';

Handler routeHandler() {
  final router = Router().plus
    ..use(logRequests())
    ..get(
      '/health',
      () => 'I`m fine!',
    )
    ..get(
      '/shared/view',
      sharedViewController,
    )
    ..get(
      '/chat',
      chatController,
    )
    ..post(
      '/api/user/login',
      userLoginController,
    )
    ..post(
      '/api/user/register',
      userRegisterController,
    );

  return router.call;
}
