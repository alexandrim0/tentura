import 'package:injectable/injectable.dart';

import 'comment_repository.dart';

export 'package:tentura_server/domain/entity/comment_entity.dart';

@Singleton(
  as: CommentRepository,
  env: [
    Environment.test,
  ],
)
class CommentRepositoryMock implements CommentRepository {
  @override
  Future<CommentEntity> createComment(CommentEntity comment) async =>
      _storageById[comment.id] = comment;

  @override
  Future<CommentEntity> getCommentById(String commentId) async =>
      _storageById[commentId] ?? (throw const CommentNotFoundException());

  static final _storageById = <String, CommentEntity>{};
}
