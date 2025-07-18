import 'dart:async';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_root/domain/entity/auth_request_intent.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/use_case/auth_case.dart';
import 'package:tentura_server/domain/use_case/user_presence_case.dart';

base class WebsocketSessionHandler {
  WebsocketSessionHandler(
    this.env,
    this.authCase,
    this.userPresenceCase,
  );

  final Env env;

  final AuthCase authCase;

  final UserPresenceCase userPresenceCase;

  final _sessions = <WebSocketSession, _UserSession>{};

  ///
  /// Updates last seen timestamp
  ///
  JwtEntity? touchSession(WebSocketSession session) {
    final jwt = _sessions[session]?.jwt;
    if (jwt != null) {
      _sessions[session]?.lastSeen = DateTime.now();
    }
    return jwt;
  }

  ///
  /// Remove session and stop its timer
  ///
  JwtEntity? removeSession(WebSocketSession session) {
    final removedSession = _sessions.remove(session);
    removedSession?.timer.cancel();
    return removedSession?.jwt;
  }

  ///
  /// Returns JWT by session if any else throws [UnauthorizedException]
  ///
  JwtEntity getJwtBySession(WebSocketSession session) =>
      _sessions[session]?.jwt ?? (throw const UnauthorizedException());

  ///
  /// Process type 'ping' and update presence
  ///
  Future<void> onPing(
    WebSocketSession session,
    Map<String, dynamic> message,
  ) async {
    final jwt = touchSession(session);
    if (jwt != null) {
      if (env.isPongEnabled) {
        session.send('{"type": "pong"}');
      }
      await userPresenceCase.update(userId: jwt.sub);
    }
  }

  ///
  /// Process type 'auth' and update presence
  ///
  Future<void> onAuth(
    WebSocketSession session,
    Map<String, dynamic> message,
  ) async {
    switch (message['intent']) {
      case AuthRequestIntent.cnameSignIn:
        final jwt = authCase.parseAndVerifyJwt(
          token: message['token']! as String,
        );
        _addSession(session, jwt: jwt);
        session.send(_authLogInResponse);
        await userPresenceCase.update(
          userId: jwt.sub,
          status: UserPresenceStatus.online,
        );

      case AuthRequestIntent.cnameSignOut:
        final jwt = removeSession(session);
        if (jwt != null) {
          session.send(_authLogOutResponse);
          await userPresenceCase.update(
            userId: jwt.sub,
            status: UserPresenceStatus.offline,
          );
        }

      default:
    }
  }

  ///
  /// Remove session if exists, then add the new one
  ///
  void _addSession(
    WebSocketSession session, {
    required JwtEntity jwt,
  }) {
    removeSession(session);
    _sessions[session] = _UserSession(
      lastSeen: DateTime.now(),
      timer: Timer.periodic(
        env.chatPollingInterval,
        (timer) {
          // TBD: poll updates from DB
        },
      ),
      jwt: jwt,
    );
  }

  static const _authLogInResponse =
      '{"type":"auth", '
      '"result":"success", '
      '"intent":"${AuthRequestIntent.cnameSignIn}"}';

  static const _authLogOutResponse =
      '{"type":"auth", '
      '"result":"success", '
      '"intent":"${AuthRequestIntent.cnameSignOut}"}';
}

class _UserSession {
  _UserSession({
    required this.timer,
    required this.jwt,
    required this.lastSeen,
  });

  final Timer timer;
  final JwtEntity jwt;

  DateTime lastSeen;
}
