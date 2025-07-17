import 'package:uuid/uuid_value.dart';

import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/use_case/p2p_chat_case.dart';

mixin WebsocketPathP2pChat {
  P2pChatCase get p2pChatCase;

  //
  //
  //
  Future<void> onP2pChat(
    JwtEntity jwt,
    Map<String, dynamic> payload,
  ) async {
    final intent = payload['intent']! as String;
    final message = payload['message']! as Map<String, dynamic>;
    switch (intent) {
      case 'send_message':
        await p2pChatCase.create(
          senderId: jwt.sub,
          receiverId: message['receiver_id']! as String,
          clientId: UuidValue.fromString(message['client_id']! as String),
          content: message['content']! as String,
        );

      case 'mark_as_delivered':
        await p2pChatCase.markAsDelivered(
          clientId: message['client_id']! as String,
          serverId: message['server_id']! as String,
          receiverId: jwt.sub,
        );

      default:
    }
  }
}
