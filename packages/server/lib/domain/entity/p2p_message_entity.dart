import 'package:freezed_annotation/freezed_annotation.dart';

part 'p2p_message_entity.freezed.dart';

@freezed
abstract class P2pMessageEntity with _$P2pMessageEntity {
  const factory P2pMessageEntity({
    required String clientId,
    required String content,
    required String senderId,
    required String recieverId,
    required DateTime createdAt,
    String? serverId,
    DateTime? deliveredAt,
  }) = _P2pMessageEntity;

  const P2pMessageEntity._();

  bool get isDelivered => deliveredAt != null;
}
