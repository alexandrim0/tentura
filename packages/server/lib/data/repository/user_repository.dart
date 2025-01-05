import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/user_model.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/utils/id.dart';

@Singleton(
  env: [
    Environment.dev,
    Environment.prod,
  ],
)
class UserRepository {
  UserRepository(this._database);

  final Database _database;

  Future<UserEntity> createUser({
    required String publicKey,
    String? userId,
  }) async {
    userId ??= generateId();
    final now = DateTime.timestamp();
    await _database.users.insertOne(UserInsertRequest(
      publicKey: publicKey,
      id: userId,
      title: '',
      description: '',
      hasPicture: false,
      createdAt: now,
      updatedAt: now,
    ));
    return getUserById(userId);
  }

  Future<UserEntity> getUserById(String id) async =>
      switch (await _database.users.queryUser(id)) {
        final UserModel m => m.asEntity,
        null => throw const UserNotFoundException(),
      };

  Future<UserEntity> getUserByPublicKey(String publicKey) async {
    final users = await _database.users.queryUsers(QueryParams(
      where: 'public_key=@pk',
      values: {'pk': publicKey},
    ));
    if (users.isEmpty) {
      throw const UserNotFoundException();
    }
    return (users.first as UserModel).asEntity;
  }
}

class UserNotFoundException implements Exception {
  const UserNotFoundException([this.message]);

  final String? message;

  @override
  String toString() => 'UserNotFoundException: [$message]';
}
