import 'package:shelf_plus/shelf_plus.dart';

import 'path_handler/websocket_path_p2p_chat.dart';
import 'path_handler/websocket_path_user_presence.dart';
import 'websocket_session_handler_base.dart';

base mixin WebsocketSubscriptionRouter
    on
        WebsocketSessionHandlerBase,
        WebsocketPathUserPresence,
        WebsocketPathP2pChat {
  Future<void> onSubscription(
    WebSocketSession session,
    Map<String, dynamic> message,
  ) {
    final jwt = getJwtBySession(session);
    final payload = message['payload'];
    if (payload is Map<String, dynamic>) {
      return switch (message['path']) {
        'p2p_chat' => onP2pChatSubscription(jwt, payload),
        _ => throw UnsupportedError('Unsupported path'),
      };
    }
    throw const FormatException('Invalid payload');
  }
}
