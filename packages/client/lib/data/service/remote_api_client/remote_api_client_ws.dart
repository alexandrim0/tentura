import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'enum.dart';
import 'auth_box.dart';
import 'remote_api_client_base.dart';

base mixin RemoteApiClientWs on RemoteApiClientBase {
  // Finals
  final _messagesController =
      StreamController<Map<String, dynamic>>.broadcast();

  final _stateController = StreamController<WebSocketState>.broadcast();

  // Vars
  Timer? _wsPingTimer;

  WebSocket? _webSocket;

  StreamSubscription<dynamic>? _messagesSubscription;

  StreamSubscription<ConnectionState>? _stateSubscription;

  bool _hasAuthenticated = false;

  // Getters
  String get wsEndpointUrl;

  Duration get wsPingInterval;

  bool get isReady => _hasAuthenticated && _webSocket != null;

  Stream<Map<String, dynamic>> get webSocketMessages =>
      _messagesController.stream;

  Stream<WebSocketState> get webSocketState => _stateController.stream;

  Future<bool> get webSocketIsReady => webSocketState
      .firstWhere((e) => e == WebSocketState.connected)
      .then(
        (_) => true,
        onError: (_) => false,
      );

  ///
  @override
  @mustCallSuper
  Future<String?> setAuth({
    required String seed,
    required AuthTokenFetcher authTokenFetcher,
    AuthRequestIntent? returnAuthRequestToken,
  }) async {
    _webSocket ??= WebSocket(Uri.parse(wsEndpointUrl));
    _wsPingTimer ??= Timer.periodic(
      wsPingInterval,
      _onTimer,
    );
    _stateSubscription ??= _webSocket?.connection.listen(
      _onConnectionChanged,
      cancelOnError: false,
    );
    _messagesSubscription ??= _webSocket?.messages.listen(
      _onMessage,
      cancelOnError: false,
    );

    return super.setAuth(
      seed: seed,
      authTokenFetcher: authTokenFetcher,
      returnAuthRequestToken: returnAuthRequestToken,
    );
  }

  ///
  @override
  @mustCallSuper
  Future<void> dropAuth() async {
    await _dropAuth();
    return super.dropAuth();
  }

  ///
  @override
  @mustCallSuper
  Future<void> close() async {
    await _dropAuth();
    return super.close();
  }

  ///
  ///
  ///
  void webSocketSend(dynamic message) {
    if (_hasAuthenticated) {
      _webSocket?.send(message);
    }
  }

  //
  //
  Future<void> _dropAuth() async {
    _hasAuthenticated = false;
    _wsPingTimer?.cancel();
    _wsPingTimer = null;
    _webSocket?.send(
      '{"type":"auth","intent":"${AuthRequestIntent.cnameSignOut}"}',
    );
    await _messagesSubscription?.cancel();
    _messagesSubscription = null;
    await _stateSubscription?.cancel();
    _stateSubscription = null;
    _stateController.add(WebSocketState.disconnected);
    _webSocket?.close();
    _webSocket = null;
  }

  //
  //
  void _onTimer(_) {
    if (isReady) {
      _webSocket?.send('{"type":"ping"}');
    }
  }

  //
  //
  Future<void> _onConnectionChanged(ConnectionState state) async {
    if (state is Connected || state is Reconnected) {
      _webSocket?.send(await _buildAuthMessage());
    } else {
      _hasAuthenticated = false;
      _stateController.add(WebSocketState.disconnected);
    }
  }

  //
  //
  void _onMessage(dynamic messageRaw) {
    final message = switch (messageRaw) {
      final String m => jsonDecode(m),
      // final Uint8List m => messageRaw,
      _ => throw UnsupportedError('Unknown message format'),
    };

    if (message is Map<String, dynamic>) {
      switch (message['type']) {
        case 'pong':
          break;

        case 'auth':
          switch (message['intent']) {
            case AuthRequestIntent.cnameSignIn:
            case AuthRequestIntent.cnameSignUp:
              if (message['result'] == 'success') {
                _hasAuthenticated = true;
                _stateController.add(WebSocketState.connected);
              }

            case AuthRequestIntent.cnameSignOut:
              _hasAuthenticated = false;
              _stateController.add(WebSocketState.disconnected);

            default:
          }

        default:
          _messagesController.add(message);
      }
    }
  }

  //
  //
  Future<String> _buildAuthMessage() async => jsonEncode({
    'type': 'auth',
    'intent': AuthRequestIntent.cnameSignIn,
    'token': (await getAuthToken()).accessToken,
  });
}
