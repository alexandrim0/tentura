import 'package:stormberry/stormberry.dart';

import 'package:tentura_server/domain/entity/vote_user_entity.dart';

import '../service/converter/timestamptz_converter.dart';
import 'user_model.dart';

part 'vote_user_model.schema.dart';

extension type const VoteUserModel(VoteUserView i) implements VoteUserView {
  VoteUserEntity get asEntity => VoteUserEntity(
    subject: (subject as UserModel).asEntity,
    object: (object as UserModel).asEntity,
    amount: amount,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

@Model(tableName: 'vote_user')
abstract class VoteUser {
  VoteUser({
    required this.subject,
    required this.object,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  final User subject;

  final User object;

  final int amount;

  @UseConverter(TimestamptzConverter())
  final DateTime createdAt;

  @UseConverter(TimestamptzConverter())
  final DateTime updatedAt;
}
