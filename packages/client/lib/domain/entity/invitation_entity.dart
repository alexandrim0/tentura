import 'package:freezed_annotation/freezed_annotation.dart';

import 'identifiable.dart';

part 'invitation_entity.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class InvitationEntity extends Identifiable with _$InvitationEntity {
  const factory InvitationEntity({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? invitedId,
  }) = _InvitationEntity;

  const InvitationEntity._();
}
