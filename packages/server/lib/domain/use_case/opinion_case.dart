import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/opinion_repository.dart';
import 'package:tentura_server/domain/entity/opinion_entity.dart';

@Injectable(order: 2)
class OpinionCase {
  OpinionCase(this._opinionRepository);

  final OpinionRepository _opinionRepository;

  Future<OpinionEntity> getOpinionById(String id) =>
      _opinionRepository.getOpinionById(id);
}
