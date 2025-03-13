import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/domain/entity/jwt_entity.dart';

import '../_base_controller.dart';

abstract base class UserController extends BaseController {
  UserController(this.userRepository);

  final UserRepository userRepository;

  @override
  Future<Response> handler(Request request);
}

extension RequestUserX on Request {
  String get userId => (context[JwtEntity.key]! as JwtEntity).sub;
}
