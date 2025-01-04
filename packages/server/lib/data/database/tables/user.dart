import 'package:stormberry/stormberry.dart';

part 'user.schema.dart';

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
