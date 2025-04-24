import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/domain/entity/opinion_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';

import '../service/converter/timestamptz_converter.dart';
import 'user_model.dart';

part 'opinion_model.schema.dart';

extension type const OpinionModel(OpinionView i) implements OpinionView {
  OpinionEntity toEntity({required UserEntity object}) => OpinionEntity(
    id: id,
    score: amount,
    content: content,
    createdAt: createdAt,
    author: (subject as UserModel).asEntity,
    user: object,
  );
}

@Model(tableName: 'opinion')
abstract class Opinion {
  @PrimaryKey()
  String get id;

  User get subject;

  String get object;

  int get amount;

  String get content;

  @UseConverter(TimestamptzConverter())
  DateTime get createdAt;
}
