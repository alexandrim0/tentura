import 'dart:async';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

import 'image_case_mixin.dart';

@Injectable(order: 2)
class UserCase with ImageCaseMixin {
  const UserCase(this._imageRepository, this._userRepository);

  final ImageRepository _imageRepository;

  final UserRepository _userRepository;

  Future<UserEntity> updateProfile({
    required String id,
    String? title,
    String? description,
    Stream<Uint8List>? imageBytes,
    bool? dropImage,
  }) async {
    if (dropImage ?? false) {
      await _imageRepository.deleteUserImage(userId: id);
      await _userRepository.updateUser(
        id: id,
        title: title,
        description: description,
        hasImage: false,
        blurHash: '',
        imageHeight: 0,
        imageWidth: 0,
      );
    } else if (imageBytes != null) {
      await _imageRepository.putUserImage(userId: id, bytes: imageBytes);
      await _userRepository.updateUser(
        id: id,
        title: title,
        description: description,
        hasImage: true,
        blurHash: '',
        imageHeight: 0,
        imageWidth: 0,
      );
      unawaited(updateBlurHash(userId: id));
    } else {
      await _userRepository.updateUser(
        id: id,
        title: title,
        description: description,
      );
    }
    return UserEntity(id: id);
  }

  Future<bool> deleteById({required String id}) async {
    await _userRepository.deleteUserById(id: id);
    await _imageRepository.deleteUserImageAll(userId: id);
    return true;
  }

  Future<void> updateBlurHash({required String userId}) async {
    try {
      final imageBytes = await _imageRepository.getUserImage(userId: userId);
      final image = decodeImage(imageBytes);
      await _userRepository.updateUser(
        id: userId,
        blurHash: calculateBlurHash(image),
        imageHeight: image.height,
        imageWidth: image.width,
      );
    } catch (e) {
      print(e);
    }
  }
}
