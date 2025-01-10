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
      storageByPublicKey[publicKey] = user;

  @override
  Future<UserEntity> getUserById(String id) async =>
      storageByPublicKey.values.where((e) => e.id == id).firstOrNull ??
      (throw IdNotFoundException(id));

  @override
  Future<UserEntity> getUserByPublicKey(String publicKey) async =>
      storageByPublicKey[publicKey] ?? (throw IdNotFoundException(publicKey));

  /// Mock data for tests and dev mode
  static final storageByPublicKey = <String, UserEntity>{
    // Thorin Oakenshield
    'U286f94380611': const UserEntity(
      id: 'U286f94380611',
      title: 'Thorin Oakenshield',
      description: 'Son of Thrain, son of Thror, King under the Mountain',
      hasPicture: true,
    ),

    // Dain Ironfoot
    'U8ebde6fbfd3f': const UserEntity(
      id: 'U8ebde6fbfd3f',
      title: 'Dain Ironfoot',
      description: '''
CEO of Ironfoot Industries and the Lord of the Iron Hills. Veteran in resource extraction and heavy manufacturing. When the chips are down, I’m the guy you want in your corner. Tough decisions? I make them every day. 👊 Always looking for the next big opportunity in heavy industry and infrastructure.''',
      hasPicture: true,
    ),

    // Gandalf
    'U2becfc64c13b': const UserEntity(
      id: 'U2becfc64c13b',
      title: 'Gandalf the Gray',
      description: '''
Experienced business angel and startup mentor with a knack for turning risky ventures into legendary success stories. Disrupting the market since before it was cool. Occasionally disappear to let teams find their own path, but always return at the right moment. DM for networking and strategic advice.''',
      hasPicture: true,
    ),

    // User without picture
    'U4d9267c70eab': const UserEntity(
      id: 'U4d9267c70eab',
      title: 'The Anonymous of Dol Guldur',
      description: '''
Let's save the nature and cultural traditions of Middle-earth! 

Activist, publicist, concerned neighbor and representative of one of the largest communities in Middle-earth.''',
    ),
  };
}
