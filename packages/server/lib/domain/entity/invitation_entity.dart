import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_server/utils/id.dart';

import 'user_entity.dart';

part 'invitation_entity.freezed.dart';

@freezed
abstract class InvitationEntity with _$InvitationEntity {
  static String get newId => generateId('I');

  const factory InvitationEntity({
    required String id,
    required UserEntity issuer,
    required DateTime createdAt,
    required DateTime updatedAt,
    UserEntity? invited,
  }) = _IntitationEntity;

  const InvitationEntity._();
}
