import 'package:stormberry/stormberry.dart' hide DateRange;
import 'package:tentura_server/domain/entity/opinion_entity.dart';

import '../service/converter/timestamptz_converter.dart';
import 'user_model.dart';

part 'opinion_model.schema.dart';

extension type const OpinionModel(OpinionView i) implements OpinionView {
  OpinionEntity get asEntity => OpinionEntity(
    id: id,
    content: content,
    createdAt: createdAt,
    author: (subject as UserModel).asEntity,
    user: (object as UserModel).asEntity,
    score: amount,
  );
}

@Model(tableName: 'opinion')
abstract class Opinion {
  @PrimaryKey()
  String get id;

  User get subject;

  User get object;

  String get content;

  @UseConverter(TimestamptzConverter())
  DateTime get createdAt;

  int get amount;

  int get ticker;
}
