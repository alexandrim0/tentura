import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/data/service/image_service.dart';

import 'user_repository.dart';

@Injectable(as: UserRepository, env: [Environment.test], order: 1)
class UserRepositoryMock implements UserRepository {
  static final storageByPublicKey = <String, UserEntity>{};

  UserRepositoryMock(this._imageService);

  final ImageService _imageService;

  @override
  Future<UserEntity> createUser({required UserEntity user}) async =>
      storageByPublicKey.containsKey(user.publicKey)
          ? throw Exception('Key already exists [${user.publicKey}]')
          : storageByPublicKey[user.publicKey] = user;

  @override
  Future<UserEntity> getUserById(String id) async =>
      storageByPublicKey.values.where((e) => e.id == id).firstOrNull ??
      (throw IdNotFoundException(id: id));

  @override
  Future<UserEntity> getUserByPublicKey(String publicKey) async =>
      storageByPublicKey[publicKey] ??
      (throw IdNotFoundException(id: publicKey));

  @override
  Future<void> setUserImage({
    required String id,
    required Uint8List imageBytes,
  }) async {
    final entry =
        storageByPublicKey.entries.where((e) => e.value.id == id).firstOrNull ??
        (throw IdNotFoundException(id: id));
    final image = _imageService.decodeImage(imageBytes);
    final blurHash = _imageService.calculateBlurHash(image);
    storageByPublicKey[entry.key] = entry.value.copyWith(
      blurHash: blurHash,
      hasPicture: true,
      picHeight: image.height,
      picWidth: image.width,
    );
  }

  @override
  Future<void> deleteUserById({required String id}) async {
    storageByPublicKey.removeWhere((_, e) => e.id == id);
  }
}
