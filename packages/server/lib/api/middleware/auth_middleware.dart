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
  /// Extract and verify bearer JWT.
  /// If ok, save it in request.context[kContextUserId]
  ///
  Middleware get verifyBearerJwt =>
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
            return Response.unauthorized(null);
          };

  ///
  /// Check password from X-Tentura-Password header
  ///
  Middleware get verifyTenturaPassword =>
      (Handler innerHandler) => (Request request) {
            // Pass if password is not set
            if (kTenturaPassword?.isEmpty ?? true) {
              return innerHandler(request);
            }
            // Pass if password is correct
            if (request.headers['X-Tentura-Password'] == kTenturaPassword) {
              return innerHandler(request);
            }
            // Else return 401
            return Response.unauthorized(null);
          };
}
