import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/utils/id.dart';
import 'package:tentura_server/utils/jwt.dart';

import 'user_controller.dart';

@Injectable(order: 3)
final class UserRegisterController extends UserController {
  UserRegisterController(super.userRepository);

  @override
  Future<Response> handler(Request request) async {
    try {
      final jwt = verifyAuthRequest(
        token: extractAuthTokenFromHeaders(request.headers),
      );
      final user = await userRepository.createUser(
        user: UserEntity(
          id: generateId('U'),
          publicKey: (jwt.payload as Map)['pk'] as String,
        ),
      );
      return Response.ok(jsonEncode(issueJwt(subject: user.id)));
    } catch (e) {
      print(e);
      return Response.unauthorized(null);
    }
  }
}
