import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';

part 'user_model.schema.dart';

extension type const UserModel(UserView i) implements UserView {
  UserEntity get asEntity => UserEntity(
        id: id,
        title: title,
        description: description,
        hasPicture: hasPicture,
      );
}

@Model(
  tableName: 'user',
  indexes: [
    TableIndex(
      name: 'user_public_key_key',
      columns: ['public_key'],
      unique: true,
    ),
  ],
)
abstract class User {
  @PrimaryKey()
  String get id;

  String get title;

  String get description;

  String get publicKey;

  DateTime get createdAt;

  DateTime get updatedAt;

  bool get hasPicture;
}
