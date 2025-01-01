import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../utils/jwt.dart';
import 'user_controller.dart';

@Singleton(
  order: 1,
)
final class UserRegisterController extends UserController {
  UserRegisterController(
    super.logger,
    super.userRepository,
  );

  @override
  Future<Response> handler(Request request) async {
    try {
      final jwt = verifyAuthRequest(
        token: extractAuthToken(
          headers: request.headers,
        ),
      );
      final user = await userRepository.createUser(
        publicKey: (jwt.payload as Map)['pk'] as String,
      );

      return Response.ok(
        jsonEncode(issueJwt(subject: user.id)),
      );
    } catch (e) {
      logger.e(e);

      return Response.unauthorized(e);
    }
  }
}
