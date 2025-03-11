import 'dart:async';
import 'dart:isolate';
import 'package:ferry/ferry.dart'
    show Client, OperationRequest, OperationResponse;
import 'package:ferry/ferry_isolate.dart';

import 'package:tentura_root/consts.dart';

import 'remote_api_client_base.dart';
import 'gql_client.dart';

typedef GetTokenRequest = ({DateTime getTokenRequestTimestamp});

typedef GetTokenResponse = ({String? token, Object? error});

base class RemoteApiClient extends RemoteApiClientBase {
  RemoteApiClient({
    required super.apiUrlBase,
    required super.jwtExpiresIn,
    required super.requestTimeout,
    required super.userAgent,
  });

  late final SendPort _replyPort;

  late final IsolateClient _gqlClient;

  @override
  Future<void> init() async {
    _gqlClient = await IsolateClient.create<ClientParams>(
      _initClient,
      params: params,
      messageHandler: _messageHandler,
    );
  }

  @override
  Future<void> close() async {
    await super.close();
    await _gqlClient.dispose();
  }

  @override
  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
      OperationRequest<TData, TVars>,
    )?
    forward,
  ]) => _gqlClient.request(request);

  Future<Client> _initClient(ClientParams params, SendPort? sendPort) async {
    final receivePort = ReceivePort();
    sendPort?.send(receivePort.sendPort);
    final tokenStream =
        receivePort
            .where((e) => e is GetTokenResponse)
            .cast<GetTokenResponse>()
            .asBroadcastStream();

    Future<String?> getAuthToken() async {
      sendPort?.send((getTokenRequestTimestamp: DateTime.timestamp()));
      final response = await tokenStream.first.timeout(
        const Duration(seconds: kRequestTimeout),
      );
      return response.token;
    }

    return buildClient(params: params, getToken: getAuthToken);
  }

  Future<void> _messageHandler(Object? message) async {
    if (message is GetTokenRequest) {
      try {
        _replyPort.send((token: await getToken(), error: null));
      } catch (e) {
        _replyPort.send((token: null, error: e));
      }
    } else if (message is SendPort) {
      _replyPort = message;
    }
  }
}
