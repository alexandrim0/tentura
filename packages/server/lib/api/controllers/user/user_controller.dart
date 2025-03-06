import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

import '../_base_controller.dart';

abstract base class UserController extends BaseController {
  UserController(this.userRepository);

  final UserRepository userRepository;

  @override
  Future<Response> handler(Request request);
}

extension RequestUserX on Request {
  String get userId => context[kContextUserId]! as String;
}
