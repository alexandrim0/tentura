import 'dart:async';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/data/repository/tasks_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

import '../entity/task_entity.dart';

@Injectable(order: 2)
class UserCase {
  const UserCase(
    this._imageRepository,
    this._userRepository,
    this._tasksRepository,
  );

  final ImageRepository _imageRepository;

  final UserRepository _userRepository;

  final TasksRepository _tasksRepository;

  Future<UserEntity> updateProfile({
    required String id,
    String? title,
    String? description,
    Stream<Uint8List>? imageBytes,
    bool? dropImage,
  }) async {
    if (dropImage ?? false) {
      await _imageRepository.deleteUserImage(userId: id);
      await _userRepository.update(
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
      await _userRepository.update(
        id: id,
        title: title,
        description: description,
        hasImage: true,
        blurHash: '',
        imageHeight: 0,
        imageWidth: 0,
      );
      await _tasksRepository.schedule(
        TaskProfileImageHash(details: TaskProfileImageHashDetails(userId: id)),
      );
    } else {
      await _userRepository.update(
        id: id,
        title: title,
        description: description,
      );
    }
    return UserEntity(id: id);
  }

  Future<bool> deleteById({required String id}) async {
    await _userRepository.deleteById(id: id);
    await _imageRepository.deleteUserImageAll(userId: id);
    return true;
  }
}
