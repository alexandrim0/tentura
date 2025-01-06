import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/comment_model.dart';
import 'package:tentura_server/domain/entity/comment_entity.dart';

export 'package:tentura_server/domain/entity/comment_entity.dart';

@Singleton(
  env: [
    Environment.dev,
    Environment.prod,
  ],
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

  Future<CommentEntity> getCommentById(String commentId) async =>
      switch (await _database.comments.queryComment(commentId)) {
        final CommentModel m => m.asEntity,
        null => throw const CommentNotFoundException(),
      };
}

class CommentNotFoundException implements Exception {
  const CommentNotFoundException([this.message]);

  final String? message;

  @override
  String toString() => 'CommentNotFoundException: [$message]';
}
