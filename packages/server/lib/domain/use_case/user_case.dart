import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

@Injectable(order: 2)
class UserCase {
  const UserCase(this._imageRepository, this._userRepository);

  final ImageRepository _imageRepository;

  final UserRepository _userRepository;

  Future<bool> updateProfile({
    required String id,
    String? title,
    String? description,
    Stream<Uint8List>? imageBytes,
  }) async {
    if (imageBytes != null) {
      await _imageRepository.putUserImage(userId: id, bytes: imageBytes);
    }
    await _userRepository.updateUser(
      id: id,
      title: title,
      description: description,
      hasImage: imageBytes != null,
    );
    return true;
  }

  Future<bool> deleteById({required String id}) async {
    await _userRepository.deleteUserById(id: id);
    await _imageRepository.deleteUserImageAll(id: id);
    return true;
  }
}
