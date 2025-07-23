import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token_entity.freezed.dart';

@freezed
abstract class FcmTokenEntity with _$FcmTokenEntity {
  const factory FcmTokenEntity({
    required String userId,
    required String appId,
    required String token,
    required String platform,
    required DateTime createdAt,
  }) = _FcmTokenEntity;

  const FcmTokenEntity._();
}
