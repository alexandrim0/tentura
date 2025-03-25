import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/domain/entity/comment_entity.dart';

import '../service/converter/timestamptz_converter.dart';
import 'beacon_model.dart';
import 'user_model.dart';

part 'comment_model.schema.dart';

extension type const CommentModel(CommentView i) implements CommentView {
  CommentEntity get asEntity => CommentEntity(
    id: id,
    content: content,
    createdAt: createdAt,
    author: (user as UserModel).asEntity,
    beacon: (beacon as BeaconModel).asEntity,
  );
}

@Model(tableName: 'comment')
abstract class Comment {
  @PrimaryKey()
  String get id;

  String get content;

  @UseConverter(TimestamptzConverter())
  DateTime get createdAt;

  Beacon get beacon;

  User get user;

  int get ticker;
}
