import 'dart:async';
import 'package:ferry/ferry.dart' show OperationRequest, OperationResponse;
import 'package:flutter/foundation.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'auth_box.dart';
import 'credentials.dart';
import 'exception.dart';

typedef GqlFetcher =
    Stream<OperationResponse<TData, TVars>> Function<TData, TVars>(
      OperationRequest<TData, TVars> request, [
      Stream<OperationResponse<TData, TVars>> Function(
        OperationRequest<TData, TVars>,
      )?
      forward,
    ]);

abstract class RemoteApiClientBase {
  RemoteApiClientBase({
    required this.authJwtExpiresIn,
    required this.apiEndpointUrl,
    required this.wsEndpointUrl,
    required this.wsPingInterval,
    required this.requestTimeout,
    required this.userAgent,
  }) {
    _webSocket = WebSocket(Uri.parse(wsEndpointUrl));
    _wsPingTimer = Timer.periodic(
      wsPingInterval,
      (_) => _webSocket.send('{"type":"ping"}'),
    );
  }

  final String userAgent;
  final String wsEndpointUrl;
  final String apiEndpointUrl;
  final Duration requestTimeout;
  final Duration wsPingInterval;
  final Duration authJwtExpiresIn;

  late final Timer _wsPingTimer;
  late final WebSocket _webSocket;

  bool _tokenLocked = false;

  AuthBox? _authBox;

  Stream<dynamic> get webSocketMessages => _webSocket.messages;

  Stream<ConnectionState> get webSocketConnection => _webSocket.connection;

  void webSocketSend(dynamic message) => _webSocket.send(message);

  ///
  /// Returns Auth Request JWT
  ///
  @mustCallSuper
  Future<String?> setAuth({
    required String seed,
    required AuthTokenFetcher authTokenFetcher,
    AuthRequestIntent? returnAuthRequestToken,
  }) async {
    if (seed.isEmpty) {
      throw const AuthenticationNoKeyException();
    }
    _tokenLocked = false;
    _authBox = AuthBox.fromSeed(
      seed: seed,
      authTokenFetcher: authTokenFetcher,
    );
    return returnAuthRequestToken == null
        ? null
        : _authBox!.getAuthRequestToken(returnAuthRequestToken);
  }

  //
  //
  //
  @mustCallSuper
  void dropAuth() {
    _authBox = null;
    _tokenLocked = false;
  }

  //
  //
  //
  @mustCallSuper
  Future<void> close() async {
    dropAuth();
    _wsPingTimer.cancel();
    _webSocket.close();
  }

  //
  //
  //
  @mustCallSuper
  Future<Credentials> getAuthToken() async {
    if (_authBox == null) {
      throw const AuthenticationNoKeyException();
    }
    if (_authBox!.hasValidToken) {
      return _authBox!.credentials!;
    }
    if (_tokenLocked) {
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration(milliseconds: 100 + 100 * i));
        if (!_tokenLocked && (_authBox?.hasValidToken ?? false)) {
          return _authBox!.credentials!;
        }
      }
      throw TimeoutException('Timeout while refreshing token!');
    } else {
      _tokenLocked = true;
      try {
        final credentials = await _authBox!.fetchCredentials(request);
        _authBox = _authBox!.copyWith(credentials: credentials);
        return credentials;
      } finally {
        _tokenLocked = false;
      }
    }
  }

  //
  //
  //
  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
      OperationRequest<TData, TVars>,
    )?
    forward,
  ]);
}
