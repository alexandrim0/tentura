import 'package:injectable/injectable.dart';
import 'package:stormberry/stormberry.dart';
import 'package:tentura_server/data/model/user_model.dart';

import 'package:tentura_server/domain/entity/opinion_entity.dart';
import 'package:tentura_server/domain/exception.dart';

@Injectable(env: [Environment.dev, Environment.prod], order: 1)
class OpinionRepository {
  OpinionRepository(this._database);

  final Database _database;

  Future<OpinionEntity> getOpinionById(String id) async {
    final result = await _database.execute(
      """SELECT * FROM "opinion" WHERE id='$id'""",
    );
    if (result.isEmpty) {
      throw IdNotFoundException(id: id);
    }

    final json = result.first.toColumnMap();
    final authorId = json['subject']! as String;
    final author = await _database.users.queryUser(authorId);
    if (author == null) {
      throw IdNotFoundException(id: id);
    }
    final user = await _database.users.queryUser(json['object']! as String);
    if (user == null) {
      throw IdNotFoundException(id: id);
    }

    return OpinionEntity(
      id: id,
      score: json['amount']! as int,
      content: json['content']! as String,
      createdAt: json['created_at']! as DateTime,
      author: (author as UserModel).asEntity,
      user: (user as UserModel).asEntity,
    );
  }
}
