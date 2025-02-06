import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/di/di.dart';

import 'controllers/actions/action_blur_hash_controller.dart';
import 'controllers/chat/chat_controller.dart';
import 'controllers/user/user_image_controller.dart';
import 'controllers/user/user_login_controller.dart';
import 'controllers/user/user_register_controller.dart';
import 'controllers/shared/shared_view_controller.dart';
import 'middleware/auth_middleware.dart';

Handler routeHandler() {
  final authMiddleware = getIt<AuthMiddleware>();
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
      kPathAppLinkView,
      sharedViewController,
    )
    ..post(
      kPathLogin,
      getIt<UserLoginController>().handler,
    )
    ..post(
      kPathRegister,
      getIt<UserRegisterController>().handler,
    )
    ..put(
      kPathImageUpload,
      getIt<UserImageController>().handler,
      use: authMiddleware.verifyBearerJwt,
    )
    ..post(
      '$kPathActions/blur_hash',
      getIt<ActionBlurHashController>().handler,
      use: authMiddleware.verifyTenturaPassword,
    );

  return router.call;
}
