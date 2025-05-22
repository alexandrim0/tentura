import 'package:tentura_server/domain/entity/user_entity.dart';

import '../database/tentura_db.dart';

mixin UserMapper {
  UserEntity userModelToEntity(User model) => UserEntity(
    id: model.id,
    title: model.title,
    publicKey: model.publicKey,
    description: model.description,
    hasPicture: model.hasPicture,
    picHeight: model.picHeight,
    picWidth: model.picWidth,
    blurHash: model.blurHash,
  );
}
