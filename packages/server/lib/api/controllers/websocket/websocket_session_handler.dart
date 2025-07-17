import 'dart:async';
import 'package:shelf_plus/shelf_plus.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/entity/jwt_entity.dart';

base class WebsocketSessionHandler {
  WebsocketSessionHandler(this.env);

  final Env env;

  final _sessions = <WebSocketSession, _UserSession>{};

  ///
  /// Remove session if exists, then add the new one
  ///
  void addSession(
    WebSocketSession session, {
    required JwtEntity jwt,
  }) {
    removeSession(session);
    _sessions[session] = _UserSession(
      timer: Timer.periodic(
        env.chatPollingInterval,
        (timer) {
          // TBD: poll updates from DB
        },
      ),
      jwt: jwt,
      lastSeen: DateTime.now(),
    );
  }

  ///
  /// Updates last seen timestamp, returns 'true' if exists
  ///
  bool touchSession(WebSocketSession session) =>
      (_sessions[session]?.lastSeen = DateTime.now()) != null;

  ///
  /// Remove session and stop its timer
  ///
  void removeSession(WebSocketSession session) {
    _sessions.remove(session)?.timer.cancel();
  }

  //
  //
  //
  JwtEntity getJwtBySession(WebSocketSession session) =>
      _sessions[session]?.jwt ?? (throw const UnauthorizedException());
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
