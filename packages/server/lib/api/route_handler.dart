import 'package:shelf_plus/shelf_plus.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/di/di.dart';

import 'controllers/events_controller.dart';
import 'controllers/chat/chat_controller.dart';
import 'controllers/graphql_controller.dart';
import 'controllers/user/user_image_controller.dart';
import 'controllers/user/user_login_controller.dart';
import 'controllers/user/user_register_controller.dart';
import 'controllers/shared/shared_view_controller.dart';
import 'middleware/auth_middleware.dart';

Handler routeHandler() {
  final authMiddleware = getIt<AuthMiddleware>();
  final router =
      Router().plus
        ..use(logRequests())
        ..use(corsHeaders(headers: _corsHeaders))
        ..get('/health', () => 'I`m fine!')
        ..get('/chat', chatController)
        ..get(kPathAppLinkView, sharedViewController)
        ..post(kPathLogin, getIt<UserLoginController>().handler)
        ..post(kPathRegister, getIt<UserRegisterController>().handler)
        ..post(
          kPathGraphql,
          getIt<GraphqlController>().handler,
          use: authMiddleware.extractJwtClaims,
        )
        ..post(
          kPathEvents,
          getIt<EventsController>().handler,
          use: authMiddleware.verifyTenturaPassword,
        )
        ..put(
          kPathImageUpload,
          getIt<UserImageController>().handler,
          use: authMiddleware.verifyBearerJwt,
        );

  return router.call;
}

final _corsHeaders = {
  ACCESS_CONTROL_ALLOW_CREDENTIALS: 'false',
  ACCESS_CONTROL_ALLOW_ORIGIN: kServerUri.host,
};
