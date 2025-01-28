import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/utils/jwt.dart';

import 'user_controller.dart';

@Singleton(
  order: 1,
)
final class UserLoginController extends UserController {
  UserLoginController(
    super.logger,
    super.userRepository,
  );

  @override
  Future<Response> handler(Request request) async {
    try {
      final jwt = verifyAuthRequest(
        token: extractAuthTokenFromHeaders(request.headers),
      );
      final user = await userRepository
          .getUserByPublicKey((jwt.payload as Map)['pk'] as String);

      return Response.ok(
        jsonEncode(issueJwt(subject: user.id)),
      );
    } on IdNotFoundException catch (e) {
      logger.e(
        e.toString(),
        error: e,
      );
      return Response.badRequest(
        body: 'User not found',
      );
    } catch (e) {
      logger.e(
        e.toString(),
        error: e,
      );
      return Response.unauthorized(e.toString());
    }
  }
}
