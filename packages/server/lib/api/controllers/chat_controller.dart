import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/use_case/auth_case.dart';
import 'package:tentura_server/domain/use_case/chat_case.dart';

typedef UserSession = ({Timer timer, JwtEntity jwt, DateTime lastSeen});

@Singleton(order: 3)
final class ChatController {
  ChatController(
    this._env,
    this._authCase,
    this._chatCase,
  );

  final Env _env;

  final AuthCase _authCase;

  final ChatCase _chatCase;

  final _sessions = <WebSocketSession, UserSession>{};

  ///
  ///
  ///
  WebSocketSession handler() => WebSocketSession(
    onClose: (session) {
      _sessions.remove(session)?.timer.cancel();
    },
    onError: (session, error) {
      final err = 'Error occurred [$error]';
      print(err);
      session.sender.close(1000, err);
    },
    onMessage: (session, data) => switch (data) {
      final String value => _onTextMessage(
        session,
        jsonDecode(value) as Map<String, dynamic>,
      ),
      final List<int> value => _onBinaryMessage(session, value),
      _ => throw UnsupportedError('Unsupported payload type'),
    },
  );

  //
  //
  //
  Future<void> _onTextMessage(
    WebSocketSession session,
    Map<String, dynamic> message,
  ) async {
    try {
      switch (message['type']) {
        case 'ping':
          final userSession = _sessions[session];
          if (userSession != null) {
            _sessions[session] = (
              timer: userSession.timer,
              jwt: userSession.jwt,
              lastSeen: DateTime.now(),
            );
          }
          if (_env.isPongEnabled) {
            session.send('{"type":"pong"}');
          }

        case 'message':
          final response = switch (message['path']) {
            'auth' => await _onAuth(
              session,
              message['payload'] as Map<String, dynamic>,
            ),
            'chat' => await _onChat(
              session,
              message['payload'] as Map<String, dynamic>,
            ),
            _ => throw UnsupportedError('Unsupported path'),
          };
          if (response != null) {
            session.send(jsonEncode(response));
          }

        default:
      }
    } catch (e) {
      print(e);
    }
  }

  //
  //
  //
  Future<void> _onBinaryMessage(
    WebSocketSession session,
    List<int> message,
  ) async {
    print('${message.runtimeType} [$message]');
  }

  //
  //
  //
  Future<Map<String, dynamic>?> _onAuth(
    WebSocketSession session,
    Map<String, dynamic> payload,
  ) async {
    final intent = payload['intent']! as String;
    switch (intent) {
      case 'sign_in':
        final authToken = payload['token']! as String;
        final jwt = _authCase.parseAndVerifyJwt(token: authToken);
        _sessions[session] = (
          timer: Timer.periodic(
            _env.chatPollingInterval,
            // TBD: poll updates from DB
            (timer) {},
          ),
          jwt: jwt,
          lastSeen: DateTime.now(),
        );
        return {
          'type': 'message',
          'path': 'auth',
          'payload': {
            'type': 'response',
            'intent': intent,
            'userId': jwt.sub,
            'roles': jwt.roles.map((e) => e.name).toList(),
          },
        };

      case 'sign_out':
        _sessions.remove(session)?.timer.cancel();
        return {
          'type': 'message',
          'path': 'auth',
          'payload': {
            'type': 'response',
            'intent': intent,
          },
        };

      default:
        return null;
    }
  }

  //
  //
  //
  Future<Map<String, dynamic>?> _onChat(
    WebSocketSession session,
    Map<String, dynamic> payload,
  ) async {
    final jwt = _getJwtBySession(session);
    final intent = payload['intent']! as String;
    final message = payload['message']! as Map<String, dynamic>;
    switch (intent) {
      case 'send_message':
        final chatMessage = await _chatCase.create(
          senderId: jwt.sub,
          receiverId: message['receiver_id']! as String,
          content: message['content']! as String,
        );
        return {
          'type': 'message',
          'path': 'chat',
          'payload': {
            'type': 'response',
            'intent': intent,
            'result': 'success',
            'message': {
              'id': chatMessage.id,
              'createdAt': chatMessage.createdAt.toIso8601String(),
            },
          },
        };

      case 'mark_as_delivered':
        final chatMessage = await _chatCase.markAsDelivered(
          messageId: message['message_id']! as String,
          receiverId: jwt.sub,
        );
        return {
          'type': 'message',
          'path': 'chat',
          'payload': {
            'type': 'response',
            'intent': intent,
            'result': 'success',
            'message': {
              'id': chatMessage.id,
              'isDelivered': chatMessage.isDelivered,
              'updatedAt': chatMessage.updatedAt.toIso8601String(),
            },
          },
        };

      default:
        return null;
    }
  }

  //
  //
  //
  JwtEntity _getJwtBySession(WebSocketSession session) =>
      _sessions[session]?.jwt ?? (throw const UnauthorizedException());
}
