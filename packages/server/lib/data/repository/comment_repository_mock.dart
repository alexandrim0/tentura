import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/exception.dart';

import 'comment_repository.dart';

export 'package:tentura_server/domain/entity/comment_entity.dart';

@Injectable(as: CommentRepository, env: [Environment.test], order: 1)
class CommentRepositoryMock implements CommentRepository {
  static final storageById = <String, CommentEntity>{};

  @override
  Future<CommentEntity> createComment(CommentEntity comment) async =>
      storageById[comment.id] = comment;

  @override
  Future<CommentEntity> getCommentById(String id) async =>
      storageById[id] ?? (throw IdNotFoundException(id: id));
}
