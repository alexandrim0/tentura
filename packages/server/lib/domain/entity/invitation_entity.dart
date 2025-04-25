import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_entity.dart';

part 'invitation_entity.freezed.dart';

@freezed
abstract class InvitationEntity with _$InvitationEntity {
  const factory InvitationEntity({
    required String id,
    required UserEntity issuer,
    required DateTime createdAt,
    required DateTime updatedAt,
    UserEntity? invited,
  }) = _IntitationEntity;

  const InvitationEntity._();
}
