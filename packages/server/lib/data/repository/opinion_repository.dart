import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/data/model/opinion_model.dart';
import 'package:tentura_server/data/model/user_model.dart';
import 'package:tentura_server/domain/entity/opinion_entity.dart';
import 'package:tentura_server/domain/exception.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class OpinionRepository {
  OpinionRepository(this._database);

  final Database _database;

  Future<OpinionEntity> getOpinionById(String id) async {
    final opinion = await _database.opinions.queryOpinion(id) as OpinionModel?;
    if (opinion == null) {
      throw IdNotFoundException(id: id);
    }
    final user = await _database.users.queryUser(opinion.object) as UserModel?;
    if (user == null) {
      throw IdNotFoundException(id: id);
    }
    return opinion.toEntity(object: user.asEntity);
  }
}
