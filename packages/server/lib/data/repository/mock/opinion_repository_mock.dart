import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/entity/opinion_entity.dart';

import '../opinion_repository.dart';

@Injectable(
  as: OpinionRepository,
  env: [Environment.test],
  order: 1,
)
class OpinionRepositoryMock implements OpinionRepository {
  @override
  Future<OpinionEntity> getOpinionById(String id) {
    throw UnimplementedError();
  }
}
