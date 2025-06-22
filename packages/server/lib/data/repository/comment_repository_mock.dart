import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/beacon_entity.dart';
import 'package:tentura_server/domain/entity/user_entity.dart';
import 'package:tentura_server/domain/exception.dart';

import '../mapper/polling_mapper.dart';
import 'comment_repository.dart';
import '../mapper/beacon_mapper.dart';
import '../mapper/comment_mapper.dart';
import '../mapper/user_mapper.dart';

export 'package:tentura_server/domain/entity/comment_entity.dart';

@Injectable(as: CommentRepository, env: [Environment.test], order: 1)
class CommentRepositoryMock
    with UserMapper, PollingMapper, BeaconMapper, CommentMapper
    implements CommentRepository {
  static final storageById = <String, CommentEntity>{};

  @override
  Future<CommentEntity> createComment({
    required String authorId,
    required String beaconId,
    required String content,
    int ticker = 0,
  }) async {
    final now = DateTime.timestamp();
    final comment = CommentEntity(
      id: CommentEntity.newId,
      content: content,
      author: UserEntity(id: authorId),
      beacon: BeaconEntity(
        id: beaconId,
        title: '',
        author: UserEntity(id: UserEntity.newId),
        createdAt: now,
        updatedAt: now,
      ),
      createdAt: now,
    );
    return storageById[comment.id] = comment;
  }

  @override
  Future<CommentEntity> getCommentById(String id) async =>
      storageById[id] ?? (throw IdNotFoundException(id: id));
}
