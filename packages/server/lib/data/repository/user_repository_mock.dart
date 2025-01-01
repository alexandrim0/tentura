import 'package:injectable/injectable.dart';
import 'package:drift_postgres/drift_postgres.dart';

import '../../utils/id.dart';
import '../database/database.dart';
import 'user_repository.dart';

@Singleton(
  as: UserRepository,
  env: [
    Environment.test,
  ],
)
class UserRepositoryMock implements UserRepository {
  @override
  Future<UserData> createUser({
    required String publicKey,
    String? userId,
  }) async {
    final timestamp = PgDateTime(DateTime.timestamp());
    return _storage[publicKey] = UserData(
      id: userId ?? generateId(),
      publicKey: publicKey,
      createdAt: timestamp,
      updatedAt: timestamp,
      hasPicture: false,
      description: '',
      title: '',
    );
  }

  @override
  Future<UserData?> getUserByPublicKey({
    required String publicKey,
  }) async {
    return _storage[publicKey];
  }

  static final _storage = <String, UserData>{};
}
