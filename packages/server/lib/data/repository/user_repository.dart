import 'package:injectable/injectable.dart';

import '../../utils/id.dart';
import '../database/database.dart';

@Singleton(
  env: [
    Environment.dev,
    Environment.prod,
  ],
)
class UserRepository {
  UserRepository(this._database);

  final Database _database;

  Future<UserData> createUser({
    required String publicKey,
    String? userId,
  }) =>
      _database.managers.user.createReturning(
        (o) => o(
          id: userId ?? generateId(),
          publicKey: publicKey,
        ),
        mode: InsertMode.insert,
      );

  Future<UserData?> getUserByPublicKey({
    required String publicKey,
  }) =>
      _database.managers.user
          .filter((f) => f.publicKey.equals(publicKey))
          .getSingleOrNull();
}
