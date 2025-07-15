import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import 'package:tentura_server/env.dart';

import 'controllers/chat_controller.dart';
import 'controllers/graphiql_controller.dart';
import 'controllers/graphql_controller.dart';
import 'controllers/shared_view_controller.dart';
import 'middleware/auth_middleware.dart';

@Injectable(order: 4)
class RootRouter {
  RootRouter(
    this._env,
    this._authMiddleware,
    this._chatController,
    this._graphqlController,
    this._graphiqlController,
    this._sharedViewController,
  );

  final Env _env;

  final AuthMiddleware _authMiddleware;

  final ChatController _chatController;

  final GraphqlController _graphqlController;

  final GraphiqlController _graphiqlController;

  final SharedViewController _sharedViewController;

  Handler routeHandler() {
    final router = Router().plus
      ..use(logRequests())
      ..use(
        corsHeaders(
          headers: {
            ACCESS_CONTROL_ALLOW_CREDENTIALS: 'false',
            ACCESS_CONTROL_ALLOW_ORIGIN: _env.serverUri.host,
          },
        ),
      )
      ..get('/health', () => 'I`m fine!')
      ..get('/graphiql', _graphiqlController.handler)
      ..get(kPathAppLinkView, _sharedViewController.handler)
      ..get(kPathWebSocketEndpoint, _chatController.handler)
      ..post(
        kPathGraphQLEndpointV2,
        _graphqlController.handler,
        use: _authMiddleware.extractJwtClaims,
      );

    return router.call;
  }
}
