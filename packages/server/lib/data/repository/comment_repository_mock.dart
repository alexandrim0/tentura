import 'package:injectable/injectable.dart';
import 'package:tentura_server/domain/exception.dart';

import 'beacon_repository_mock.dart';
import 'comment_repository.dart';
import 'user_repository_mock.dart';

export 'package:tentura_server/domain/entity/comment_entity.dart';

@Injectable(
  as: CommentRepository,
  env: [
    Environment.test,
  ],
  order: 1,
)
class CommentRepositoryMock implements CommentRepository {
  @override
  Future<CommentEntity> createComment(CommentEntity comment) async =>
      storageById[comment.id] = comment;

  @override
  Future<CommentEntity> getCommentById(String id) async =>
      storageById[id] ?? (throw IdNotFoundException(id));

  /// Mock data for tests and dev mode
  static final storageById = <String, CommentEntity>{
    'C9b1d2b73215c': CommentEntity(
      id: 'C9b1d2b73215c',
      content: '14. I`ve got us a burglar.',
      createdAt: DateTime(2024, 10, 05, 10, 25, 54),
      beacon: BeaconRepositoryMock.storageById['Bc1cb783b0159']!,
      author: UserRepositoryMock.storageByPublicKey.values
          .singleWhere((e) => e.id == 'U2becfc64c13b'),
    ),
    'C1b28e93382e1': CommentEntity(
      id: 'C1b28e93382e1',
      content: 'Sorry, cousin, my boar is allergic to dragons. '
          'Wish you all the luck though!',
      createdAt: DateTime(2024, 10, 05, 10, 23, 28),
      beacon: BeaconRepositoryMock.storageById['Bc1cb783b0159']!,
      author: UserRepositoryMock.storageByPublicKey.values
          .singleWhere((e) => e.id == 'U8ebde6fbfd3f'),
    ),
  };
}
