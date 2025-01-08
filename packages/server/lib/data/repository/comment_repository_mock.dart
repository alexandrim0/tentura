import 'package:injectable/injectable.dart';
import 'package:tentura_server/domain/exception.dart';

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
  Future<CommentEntity> getCommentById(String id) async =>
      _storageById[id] ?? (throw IdNotFoundException(id));

  static final _storageById = <String, CommentEntity>{};
}
