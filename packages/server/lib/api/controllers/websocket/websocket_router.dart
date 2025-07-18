import 'dart:async';
import 'dart:convert';
import 'package:shelf_plus/shelf_plus.dart';

import 'websocket_message_handler.dart';

base class WebsocketRouter extends WebsocketMessageHandler {
  WebsocketRouter(
    super.env,
    super.authCase,
    super.userPresenceCase,
    super.p2pChatCase,
  );

  ///
  /// Process text message
  ///
  Future<void> onTextMessage(
    WebSocketSession session,
    String textMessage,
  ) async {
    try {
      final message = jsonDecode(textMessage);
      if (message is! Map<String, dynamic>) {
        throw FormatException('Wrong message [${message.runtimeType}]');
      }
      final type = message['type'];
      if (type is! String) {
        throw FormatException('Wrong type [${type.runtimeType}]');
      }
      await _dispatchMessage(type, session, message);
    } catch (e) {
      session.send(jsonEncode({'error': e.toString()}));
    }
  }

  ///
  /// Process binary message (CBOR?)
  ///
  Future<void> onBinaryMessage(
    WebSocketSession session,
    List<int> binaryMessage,
  ) async {
    throw UnimplementedError();
  }

  Future<void> _dispatchMessage(
    String messageType,
    WebSocketSession session,
    Map<String, dynamic> message,
  ) => switch (messageType) {
    'ping' => onPing(session, message),
    'auth' => onAuth(session, message),
    'message' => onMessage(session, message),
    _ => throw UnsupportedError('Unsupported message type'),
  };
}
