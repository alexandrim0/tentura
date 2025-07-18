import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura_root/domain/enums.dart';

part 'user_presence_entity.freezed.dart';

@freezed
abstract class UserPresenceEntity with _$UserPresenceEntity {
  const factory UserPresenceEntity({
    required String userId,
    required DateTime lastSeenAt,
    required UserPresenceStatus status,
  }) = _UserPresenceEntity;
}
