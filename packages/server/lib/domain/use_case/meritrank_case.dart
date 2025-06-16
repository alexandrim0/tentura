import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/meritrank_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';
import 'package:tentura_server/env.dart';

import '../enum.dart';
import '../exception.dart';

@Singleton(order: 2)
class MeritrankCase {
  const MeritrankCase(
    this._env,
    this._userRepository,
    this._meritrankRepository,
  );

  final Env _env;

  final UserRepository _userRepository;

  final MeritrankRepository _meritrankRepository;

  Future<int> init({
    required String userId,
    Iterable<UserRoles>? userRoles,
  }) async {
    if ((userRoles != null && userRoles.contains(UserRoles.admin)) ||
        (await _userRepository.getById(
          userId,
        )).hasPrivilege(UserPrivileges.mrInit)) {
      await _meritrankRepository.reset();

      final initResult = await _meritrankRepository.init();

      await _meritrankRepository.calculate(
        timeout: _env.meritrankCalculateTimeout,
      );
      return initResult;
    }
    throw const UnauthorizedException();
  }
}
