import 'package:injectable/injectable.dart';
import 'package:tentura_server/domain/exception.dart';

export 'package:tentura_server/domain/entity/user_entity.dart';

import 'user_repository.dart';

@Singleton(
  as: UserRepository,
  env: [
    Environment.test,
  ],
)
class UserRepositoryMock implements UserRepository {
  @override
  Future<UserEntity> createUser({
    required String publicKey,
    required UserEntity user,
  }) async =>
      _storageByPublicKey[publicKey] = user;

  @override
  Future<UserEntity> getUserById(String id) async =>
      _storageByPublicKey.values.where((e) => e.id == id).firstOrNull ??
      (throw IdNotFoundException(id));

  @override
  Future<UserEntity> getUserByPublicKey(String publicKey) async =>
      _storageByPublicKey[publicKey] ?? (throw IdNotFoundException(publicKey));

  static final _storageByPublicKey = <String, UserEntity>{};
}
