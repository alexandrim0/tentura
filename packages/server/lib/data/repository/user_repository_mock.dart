import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/utils/id.dart';

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
    String? userId,
  }) async =>
      _storageByPublicKey[publicKey] = UserEntity(
        id: userId ?? generateId(),
      );

  @override
  Future<UserEntity> getUserById(String id) async =>
      _storageByPublicKey.values.where((e) => e.id == id).firstOrNull ??
      (throw const UserNotFoundException());

  @override
  Future<UserEntity> getUserByPublicKey(String publicKey) async =>
      _storageByPublicKey[publicKey] ?? (throw const UserNotFoundException());

  static final _storageByPublicKey = <String, UserEntity>{};
}
