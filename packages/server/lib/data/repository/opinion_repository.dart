import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/opinion_model.dart';
import 'package:tentura_server/domain/entity/opinion_entity.dart';
import 'package:tentura_server/domain/exception.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class OpinionRepository {
  OpinionRepository(this._database);

  final Database _database;

  Future<OpinionEntity> getOpinionById(String id) async =>
      switch (await _database.opinions.queryOpinion(id)) {
        final OpinionModel m => m.asEntity,
        null => throw IdNotFoundException(id: id),
      };
}
