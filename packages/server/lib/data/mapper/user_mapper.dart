import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/domain/enum.dart';

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
    privileges: model.privileges == null
        ? null
        : {
            for (final p in model.privileges! as List<dynamic>)
              UserPrivileges.values.firstWhere((e) => e.name == p),
          },
  );
}
