import 'package:logger/logger.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../../data/repository/user_repository.dart';

abstract class UserController {
  UserController(
    this.logger,
    this.userRepository,
  );

  final Logger logger;
  final UserRepository userRepository;

  Future<Response> handler(Request request);
}
