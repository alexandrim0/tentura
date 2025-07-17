import 'dart:async';
import 'dart:convert';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_root/domain/entity/auth_request_intent.dart';

import 'package:tentura_server/domain/use_case/auth_case.dart';
import 'package:tentura_server/domain/use_case/p2p_chat_case.dart';

import 'websocket_path_p2p_chat.dart';
import 'websocket_session_handler.dart';

base class WebsocketRouter extends WebsocketSessionHandler
    with WebsocketPathP2pChat {
  WebsocketRouter(
    super.env,
    this.authCase,
    this.p2pChatCase,
  );

  @override
  final P2pChatCase p2pChatCase;

  final AuthCase authCase;

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
        throw UnsupportedError('Unsupported message type');
      }

      switch (message['type']) {
        case 'ping' when touchSession(session) && env.isPongEnabled:
          session.send(_pingResponse);

        case 'auth':
          _onAuth(session, message);

        case 'message':
          await _onMessage(session, message);

        default:
      }
    } catch (e) {
      session.send(jsonEncode({'error': e.toString()}));
    }
  }

  //
  //
  //
  void _onAuth(
    WebSocketSession session,
    Map<String, dynamic> message,
  ) {
    switch (message['intent']) {
      case AuthRequestIntent.cnameSignIn:
        addSession(
          session,
          jwt: authCase.parseAndVerifyJwt(
            token: message['token']! as String,
          ),
        );
        session.send(_authLogInResponse);

      case AuthRequestIntent.cnameSignOut:
        removeSession(session);
        session.send(_authLogOutResponse);

      default:
    }
  }

  //
  //
  //
  Future<void> _onMessage(
    WebSocketSession session,
    Map<String, dynamic> message,
  ) async {
    switch (message['path']) {
      case 'p2p_chat':
        await onP2pChat(
          getJwtBySession(session),
          message['payload']! as Map<String, dynamic>,
        );

      default:
        throw UnsupportedError('Unsupported path');
    }
  }

  static const _pingResponse = '{"type": "pong"}';

  static const _authLogInResponse =
      '{"type":"auth", '
      '"result":"success", '
      '"intent":"${AuthRequestIntent.cnameSignIn}"}';

  static const _authLogOutResponse =
      '{"type":"auth", '
      '"result":"success", '
      '"intent":"${AuthRequestIntent.cnameSignOut}"}';
}
