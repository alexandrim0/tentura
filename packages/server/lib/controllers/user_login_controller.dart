import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../data/database/database.dart';
import '../utils/jwt.dart';

Future<Response> userLoginController(Request request) async {
  try {
    final jwt = verifyAuthRequest(
      token: extractAuthToken(
        headers: request.headers,
      ),
    );
    final publicKey = (jwt.payload as Map)['pk'] as String;
    final user = await GetIt.I<Database>()
        .managers
        .user
        .filter((f) => f.publicKey.equals(publicKey))
        .getSingle();

    return Response.ok(
      jsonEncode(issueJwt(subject: user.id)),
    );
  } catch (e) {
    GetIt.I<Logger>().e(e);

    return Response.unauthorized(e);
  }
}
