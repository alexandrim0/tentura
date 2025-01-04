import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/database/tables/user.dart';

import '../../utils/id.dart';

@Singleton(
  env: [
    Environment.dev,
    Environment.prod,
  ],
)
class UserRepository {
  UserRepository(this._database);

  final Database _database;

  Future<UserView> createUser({
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
    return (await _database.users.queryUser(userId))!;
  }

  Future<UserView?> getUserByPublicKey({
    required String publicKey,
  }) async {
    final users = await _database.users.queryUsers(QueryParams(
      where: 'public_key=@pk',
      values: {'pk': publicKey},
    ));
    return users.firstOrNull;
  }
}
