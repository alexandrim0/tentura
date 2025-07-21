import 'dart:async';
import 'dart:convert';
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
    _messagesSubscription.resume();
  }

  final String userAgent;
  final String wsEndpointUrl;
  final String apiEndpointUrl;
  final Duration requestTimeout;
  final Duration wsPingInterval;
  final Duration authJwtExpiresIn;

  final _messagesController =
      StreamController<Map<String, dynamic>>.broadcast();

  late final Timer _wsPingTimer;

  late final WebSocket _webSocket;

  late final _messagesSubscription = _webSocket.messages.listen(
    (event) {
      if (event is String) {
        final json = jsonDecode(event);
        if (json is Map<String, dynamic>) {
          _messagesController.add(json);
        }
      } else if (event is Uint8List) {
        // TBD:
        // _messagesController.add(event);
      }
    },
    cancelOnError: false,
    onDone: _messagesController.close,
  );

  bool _tokenLocked = false;

  AuthBox? _authBox;

  Stream<Map<String, dynamic>> get webSocketMessages =>
      _messagesController.stream;

  Stream<ConnectionState> get webSocketConnection => _webSocket.connection;

  //
  //
  //
  @mustCallSuper
  Future<void> close() async {
    await _messagesSubscription.cancel();
    await _messagesController.close();
    _wsPingTimer.cancel();
    _webSocket.close();
    dropAuth();
  }

  ///
  ///
  ///
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
