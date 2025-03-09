import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/domain/entity/user_entity.dart';

import '../service/converter/timestamptz_converter.dart';

part 'user_model.schema.dart';

extension type const UserModel(UserView i) implements UserView {
  UserEntity get asEntity => UserEntity(
    id: id,
    title: title,
    description: description,
    hasPicture: hasPicture,
    picHeight: picHeight,
    picWidth: picWidth,
    blurHash: blurHash,
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

  @UseConverter(TimestamptzConverter())
  DateTime get createdAt;

  @UseConverter(TimestamptzConverter())
  DateTime get updatedAt;

  bool get hasPicture;

  String get blurHash;

  int get picHeight;

  int get picWidth;
}
