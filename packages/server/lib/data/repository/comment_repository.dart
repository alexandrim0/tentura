import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/comment_model.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';
import 'package:tentura_server/domain/exception.dart';

export 'package:tentura_server/domain/entity/comment_entity.dart';

@Injectable(
  env: [
    Environment.dev,
    Environment.prod,
  ],
  order: 1,
)
class CommentRepository {
  CommentRepository(this._database);

  final Database _database;

  Future<CommentEntity> createComment(CommentEntity comment) async {
    await _database.comments.insertOne(CommentInsertRequest(
      id: comment.id,
      userId: comment.author.id,
      beaconId: comment.beacon.id,
      content: comment.content,
      createdAt: comment.createdAt,
    ));
    return getCommentById(comment.id);
  }

  Future<CommentEntity> getCommentById(String id) async =>
      switch (await _database.comments.queryComment(id)) {
        final CommentModel m => m.asEntity,
        null => throw IdNotFoundException(id),
      };
}
