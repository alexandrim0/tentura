import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/di/di.dart';

import 'controllers/chat/chat_controller.dart';
import 'controllers/user/user_files.dart';
import 'controllers/user/user_login_controller.dart';
import 'controllers/user/user_register_controller.dart';
import 'controllers/shared/shared_view_controller.dart';
import 'middleware/auth_middleware.dart';

Handler routeHandler() {
  final authMiddleware = getIt<AuthMiddleware>();
  final router = Router().plus
    ..use(logRequests())
    ..use(authMiddleware.extractBearer)
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
      '/api/user/files',
      getIt<UserFilesController>().handler,
      use: authMiddleware.demandAuth,
    )
    ..post(
      '/api/user/login',
      getIt<UserLoginController>().handler,
    )
    ..post(
      '/api/user/register',
      getIt<UserRegisterController>().handler,
    );

  return router.call;
}
