import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/database/tables/user.dart' show UserView;

import '../../utils/id.dart';
import 'user_repository.dart';

@Singleton(
  as: UserRepository,
  env: [
    Environment.test,
  ],
)
class UserRepositoryMock implements UserRepository {
  @override
  Future<UserView> createUser({
    required String publicKey,
    String? userId,
  }) async {
    final timestamp = DateTime.timestamp();
    return _storage[publicKey] = UserView(
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
  Future<UserView?> getUserByPublicKey({
    required String publicKey,
  }) async {
    return _storage[publicKey];
  }

  static final _storage = <String, UserView>{};
}
