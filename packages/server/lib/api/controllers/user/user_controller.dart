import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

abstract class UserController {
  UserController(
    this.userRepository,
  );

  final UserRepository userRepository;

  Future<Response> handler(Request request);
}

extension RequestUserX on Request {
  String get userId => context[kContextUserId]! as String;
}
