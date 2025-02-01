import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_root/consts.dart';
import 'package:tentura_server/di/di.dart';

import 'controllers/chat/chat_controller.dart';
import 'controllers/user/user_image_upload.dart';
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
      kPathAppLinkView,
      sharedViewController,
    )
    ..put(
      kPathImageUpload,
      getIt<UserImageUploadController>().handler,
      use: authMiddleware.demandAuth,
    )
    ..post(
      kPathLogin,
      getIt<UserLoginController>().handler,
    )
    ..post(
      kPathRegister,
      getIt<UserRegisterController>().handler,
    );

  return router.call;
}
