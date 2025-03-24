import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

@Injectable(order: 2)
class UserCase {
  const UserCase(this._imageRepository, this._userRepository);

  final ImageRepository _imageRepository;

  final UserRepository _userRepository;

  Future<void> deleteById({required String id}) async {
    await _userRepository.deleteUserById(id: id);
    await _imageRepository.deleteUserImageAll(id: id);
  }
}
