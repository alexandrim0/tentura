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
  Middleware get extractBearer => createMiddleware(
        requestHandler: (Request request) {
          if (request.headers.containsKey(kHeaderAuthorization)) {
            try {
              final jwt = verifyJwt(
                token: extractAuthTokenFromHeaders(request.headers),
              );
              request.context[kContextUserId] = jwt.subject!;
            } catch (e) {
              final error = e.toString();
              log(error);
              return Response.unauthorized(error);
            }
          }
          return null;
        },
      );

  ///
  /// Return code 401 if no userId in context
  ///
  Middleware get demandAuth => createMiddleware(
        requestHandler: (Request request) =>
            request.context.containsKey(kContextUserId)
                ? null
                : Response.unauthorized(null),
      );
}
