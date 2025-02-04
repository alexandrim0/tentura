import 'dart:io';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/data/model/user_model.dart';
import 'package:tentura_server/data/service/image_service.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/domain/exception.dart';

export 'package:tentura_server/domain/entity/user_entity.dart';

@Injectable(
  env: [
    Environment.dev,
    Environment.prod,
  ],
  order: 1,
)
class UserRepository {
  UserRepository(
    this._database,
    this._imageService,
  );

  final Database _database;

  final ImageService _imageService;

  Future<UserEntity> createUser({
    required String publicKey,
    required UserEntity user,
  }) async {
    final now = DateTime.timestamp();
    await _database.users.insertOne(UserInsertRequest(
      publicKey: publicKey,
      id: user.id,
      title: user.title,
      description: user.description,
      hasPicture: user.hasPicture,
      picHeight: user.picHeight,
      picWidth: user.picWidth,
      blurHash: user.blurHash,
      createdAt: now,
      updatedAt: now,
    ));
    return getUserById(user.id);
  }

  Future<UserEntity> getUserById(String id) async =>
      switch (await _database.users.queryUser(id)) {
        final UserModel m => m.asEntity,
        null => throw IdNotFoundException(id),
      };

  Future<UserEntity> getUserByPublicKey(String publicKey) async {
    final users = await _database.users.queryUsers(QueryParams(
      where: 'public_key=@pk',
      values: {'pk': publicKey},
    ));
    if (users.isEmpty) {
      throw IdNotFoundException(publicKey);
    }
    return (users.first as UserModel).asEntity;
  }

  Future<void> setUserImage({
    required String id,
    required Uint8List imageBytes,
  }) async {
    final image = _imageService.decodeImage(imageBytes);
    await _imageService.saveToFile(
      imageBytes,
      File('$kImageFolderPath/$id/avatar.$kImageExt'),
    );
    final blurHash = _imageService.calculateBlurHash(image);
    await _database.users.updateOne(UserUpdateRequest(
      id: id,
      hasPicture: true,
      blurHash: blurHash,
      picHeight: image.height,
      picWidth: image.width,
    ));
  }
}
