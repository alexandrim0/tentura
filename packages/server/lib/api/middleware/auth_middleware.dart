import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/jwt.dart';

@Injectable(
  order: 2,
)
class AuthMiddleware {
  ///
  /// Extract and verify bearer token.
  /// If ok, save it in request.context[kContextUserId]
  ///
  Middleware get extractBearer =>
      (Handler innerHandler) => (Request request) async {
            if (request.headers.containsKey(kHeaderAuthorization)) {
              try {
                final jwt = verifyJwt(
                  token: extractAuthTokenFromHeaders(request.headers),
                );
                return innerHandler(request.change(
                  context: {
                    kContextUserId: jwt.subject,
                  },
                ));
              } catch (e) {
                final error = e.toString();
                log(error);
                return Response.unauthorized(error);
              }
            }
            return innerHandler(request);
          };

  ///
  /// Return code 401 if no userId in context
  ///
  Middleware get demandAuth => (Handler innerHandler) => (Request request) =>
      request.context.containsKey(kContextUserId)
          ? innerHandler(request)
          : Response.unauthorized(null);
}
