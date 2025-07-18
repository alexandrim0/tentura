import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'websocket/websocket_router.dart';

@Singleton(order: 3)
final class WebSocketController extends WebsocketRouter {
  WebSocketController(
    super.env,
    super.authCase,
    super.userPresenceCase,
    super.p2pChatCase,
  );

  WebSocketSession handler() => WebSocketSession(
    onClose: (session) {
      removeSession(session);
    },
    onError: (session, error) {
      final err = 'Error occurred [$error]';
      print(err);
      session.sender.close(1000, err);
    },
    onMessage: (session, data) => switch (data) {
      final String message => onTextMessage(session, message),
      final List<int> message => onBinaryMessage(session, message),
      _ => throw UnsupportedError('Unsupported payload type'),
    },
  );
}
