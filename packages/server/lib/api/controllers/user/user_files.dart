import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/exception.dart';

import 'user_controller.dart';

@Injectable(
  order: 3,
)
final class UserFilesController extends UserController {
  UserFilesController(
    super.userRepository,
  );

  @override
  Future<Response> handler(Request request) async {
    try {
      final user = await userRepository.getUserById(
        request.context[kContextUserId]! as String,
      );
      // TBD
      user.imageUrl;

      return Response.ok(null);
    } on IdNotFoundException catch (e) {
      final error = e.toString();
      log(error);
      return Response.badRequest(
        body: error,
      );
    } catch (e) {
      log(e.toString());
      return Response.internalServerError();
    }
  }
}
