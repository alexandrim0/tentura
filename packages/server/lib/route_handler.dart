import 'package:get_it/get_it.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'controllers/chat/chat_controller.dart';
import 'controllers/shared/shared_view_controller.dart';
import 'controllers/user/user_login_controller.dart';
import 'controllers/user/user_register_controller.dart';

Handler routeHandler() {
  final di = GetIt.I;
  final router = Router().plus
    ..use(logRequests())
    ..get(
      '/health',
      () => 'I`m fine!',
    )
    ..get(
      '/chat',
      chatController,
    )
    ..get(
      '/shared/view',
      sharedViewController,
    )
    ..post(
      '/api/user/login',
      di<UserLoginController>().handler,
    )
    ..post(
      '/api/user/register',
      di<UserRegisterController>().handler,
    );

  return router.call;
}
