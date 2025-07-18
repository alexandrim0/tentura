import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/domain/use_case/p2p_chat_case.dart';

import 'websocket_path_p2p_chat.dart';
import 'websocket_path_user_presence.dart';
import 'websocket_session_handler.dart';

base class WebsocketMessageHandler extends WebsocketSessionHandler
    with WebsocketPathUserPresence, WebsocketPathP2pChat {
  WebsocketMessageHandler(
    super.env,
    super.authCase,
    super.userPresenceCase,
    this.p2pChatCase,
  );

  @override
  final P2pChatCase p2pChatCase;

  Future<void> onMessage(
    WebSocketSession session,
    Map<String, dynamic> message,
  ) async {
    final jwt = getJwtBySession(session);
    final payload = message['payload'];
    if (payload is! Map<String, dynamic>) {
      throw const FormatException('Invalid payload');
    }
    return switch (message['path']) {
      'p2p_chat' => onP2pChat(jwt, payload),
      'user_presence' => onUserPresence(jwt, payload),
      _ => throw UnsupportedError('Unsupported path'),
    };
  }
}
