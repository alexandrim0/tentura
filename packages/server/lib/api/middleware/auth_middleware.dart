import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/utils/jwt.dart';

@Injectable(order: 2)
class AuthMiddleware {
  ///
  /// Extract and verify bearer JWT.
  /// If ok, save it in request.context[kContextUserId]
  ///
  Middleware get verifyBearerJwt =>
      (innerHandler) => (request) async {
        if (request.headers.containsKey(kHeaderAuthorization)) {
          try {
            final jwt = verifyJwt(
              token: extractAuthTokenFromHeaders(request.headers),
            );
            return innerHandler(
              request.change(
                context: {
                  kContextUserId: jwt.subject,
                  kContextUserRole: (jwt.payload as Map)['role'],
                },
              ),
            );
          } catch (e) {
            final error = e.toString();
            print(error);
            return Response.unauthorized(error);
          }
        }
        return Response.unauthorized(null);
      };

  ///
  /// Check password from X-Tentura-Password header
  ///
  Middleware get verifyTenturaPassword =>
      (innerHandler) =>
          (request) =>
              request.headers[kHeaderTenturaPassword] == kTenturaPassword
                  ? innerHandler(request)
                  : Response.unauthorized(null);

  ///
  /// Firstly check password from X-Tentura-Password header then process JWT
  ///
  Middleware get verifyHasuraClaims =>
      (innerHandler) => (request) {
        // Needed for schema fetching
        if (request.headers.containsKey(kHeaderTenturaPassword) &&
            request.headers[kHeaderTenturaPassword] == kTenturaPassword) {
          return innerHandler(request);
        }

        if (request.headers.containsKey(kHeaderAuthorization)) {
          try {
            final jwt = verifyJwt(
              token: extractAuthTokenFromHeaders(request.headers),
            );
            return innerHandler(
              request.change(
                context: {
                  kContextUserId: jwt.subject,
                  kContextUserRole: (jwt.payload as Map)['role'],
                },
              ),
            );
          } catch (e) {
            final error = e.toString();
            print(error);
            return Response.unauthorized(error);
          }
        }
        return Response.unauthorized(null);
      };
}
