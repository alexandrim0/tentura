import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/mapper/user_mapper.dart';
import 'package:tentura_server/domain/exception.dart';

import 'user_repository.dart';

@Injectable(as: UserRepository, env: [Environment.test], order: 1)
class UserRepositoryMock with UserMapper implements UserRepository {
  static final storageByPublicKey = <String, UserEntity>{};

  const UserRepositoryMock();

  @override
  Future<UserEntity> createUser({
    required String publicKey,
    required String title,
  }) async =>
      storageByPublicKey.containsKey(publicKey)
          ? throw Exception('Key already exists [$publicKey]')
          : storageByPublicKey[publicKey] = UserEntity(
            id: UserEntity.newId,
            publicKey: publicKey,
            title: title,
          );

  @override
  Future<UserEntity> createInvitedUser({
    required String invitationId,
    required String publicKey,
    required String title,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getUserById(String id) async =>
      storageByPublicKey.values.where((e) => e.id == id).firstOrNull ??
      (throw IdNotFoundException(id: id));

  @override
  Future<UserEntity> getUserByPublicKey(String publicKey) async =>
      storageByPublicKey[publicKey] ??
      (throw IdNotFoundException(id: publicKey));

  @override
  Future<void> updateUser({
    required String id,
    String? title,
    String? description,
    bool? hasImage,
    String? blurHash,
    int? imageHeight,
    int? imageWidth,
  }) async {
    final user = await getUserById(id);
    storageByPublicKey[user.publicKey] = user.copyWith(
      title: title ?? user.title,
      description: description ?? user.description,
      hasPicture: hasImage ?? user.hasPicture,
      blurHash: blurHash ?? user.blurHash,
      picHeight: imageHeight ?? user.picHeight,
      picWidth: imageWidth ?? user.picWidth,
    );
  }

  @override
  Future<void> deleteUserById({required String id}) async {
    storageByPublicKey.removeWhere((_, e) => e.id == id);
  }
}
