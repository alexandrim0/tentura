import 'package:injectable/injectable.dart';

import 'package:tentura_root/domain/enums.dart';

import 'package:tentura_server/data/repository/user_presence_repository.dart';
import 'package:tentura_server/domain/entity/user_presence_entity.dart';

export 'package:tentura_root/domain/enums.dart';

@Injectable(order: 2)
class UserPresenceCase {
  UserPresenceCase(this._userPresenceRepository);

  final UserPresenceRepository _userPresenceRepository;

  Future<UserPresenceEntity> get(String userId) =>
      _userPresenceRepository.get(userId);

  Future<void> update({
    required String userId,
    UserPresenceStatus? status,
  }) => _userPresenceRepository.update(userId, status: status);
}
