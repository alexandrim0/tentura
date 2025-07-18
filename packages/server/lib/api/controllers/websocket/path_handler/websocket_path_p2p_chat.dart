import 'package:uuid/uuid_value.dart';

import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/use_case/p2p_chat_case.dart';

base mixin WebsocketPathP2pChat {
  P2pChatCase get p2pChatCase;

  Future<void> onP2pChatMessage(
    JwtEntity jwt,
    Map<String, dynamic> payload,
  ) {
    final message = payload['message'];
    if (message is Map<String, dynamic>) {
      return switch (payload['intent']) {
        'send_message' => p2pChatCase.create(
          senderId: jwt.sub,
          receiverId: message['receiver_id']! as String,
          clientId: UuidValue.fromString(message['client_id']! as String),
          content: message['content']! as String,
        ),
        'mark_as_delivered' => p2pChatCase.markAsDelivered(
          clientId: message['client_id']! as String,
          serverId: message['server_id']! as String,
          receiverId: jwt.sub,
        ),
        final intent => throw UnsupportedError('$intent is not supported!'),
      };
    }
    throw const FormatException('Invalid message');
  }

  Future<void> onP2pChatSubscription(
    JwtEntity jwt,
    Map<String, dynamic> payload,
  ) {
    final params = payload['params'];
    if (params is Map<String, dynamic>) {
      return switch (payload['intent']) {
        'watch_updates' => p2pChatCase.onUpdatesSubscription(
          userId: jwt.sub,
          batchSize: params['batch_size'] as int?,
          from: DateTime.parse(params['from_timestamp']! as String),
        ),
        final intent => throw UnsupportedError('$intent is not supported!'),
      };
    }
    throw const FormatException('Invalid params');
  }
}
