import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

import '../entity/event_entity.dart';
import '../enum.dart';
import 'image_case_mixin.dart';

@Injectable(order: 2)
class UserCase with ImageCaseMixin {
  const UserCase(this._imageRepository, this._userRepository);

  final ImageRepository _imageRepository;

  final UserRepository _userRepository;

  Future<bool> updateProfile({
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
    } else {
      await _userRepository.updateUser(
        id: id,
        title: title,
        description: description,
      );
    }
    return true;
  }

  Future<bool> deleteById({required String id}) async {
    await _userRepository.deleteUserById(id: id);
    await _imageRepository.deleteUserImageAll(userId: id);
    return true;
  }

  Future<void> updateBlurhash({required String id}) async {
    final image = decodeImage(await _imageRepository.getUserImage(userId: id));
    await _userRepository.updateUser(
      id: id,
      blurHash: calculateBlurHash(image),
      imageHeight: image.height,
      imageWidth: image.width,
    );
  }

  Future<void> handleEvent(EventEntity event) async {
    switch (event.operation) {
      case HasuraOperation.manual:
      case HasuraOperation.update:
        final profile = event.newData!;
        if (profile['has_picture'] == true && profile['blur_hash'] == '') {
          await updateBlurhash(id: profile['id']! as String);
        }

      case HasuraOperation.delete:
      case HasuraOperation.insert:
    }
  }
}
