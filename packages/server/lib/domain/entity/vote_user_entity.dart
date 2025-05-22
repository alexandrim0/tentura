import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/data/repository/user_repository.dart';

part 'vote_user_entity.freezed.dart';

@freezed
abstract class VoteUserEntity with _$VoteUserEntity {
  const factory VoteUserEntity({
    required UserEntity subject,
    required UserEntity object,
    required int amount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VoteUserEntity;

  const VoteUserEntity._();
}
