import 'dart:async';
import 'dart:isolate';
import 'package:ferry/ferry.dart'
    show Client, OperationRequest, OperationResponse;
import 'package:ferry/ferry_isolate.dart';
import 'package:flutter/foundation.dart';

import 'auth_box.dart';
import 'build_client.dart';
import 'remote_api_client_base.dart';

class GetTokenRequest {}

typedef GetTokenResponse = ({AuthToken? token, Object? error});

abstract base class RemoteApiClient extends RemoteApiClientBase {
  RemoteApiClient({
    required super.apiEndpointUrl,
    required super.authJwtExpiresIn,
    required super.requestTimeout,
    required super.userAgent,
  });

  late final SendPort _replyPort;

  late final IsolateClient _gqlClient;

  @override
  Future<void> init() async {
    _gqlClient = await IsolateClient.create<ClientParams>(
      initClient,
      params: (
        apiEndpointUrl: apiEndpointUrl,
        requestTimeout: requestTimeout,
        userAgent: userAgent,
      ),
      messageHandler: (Object? message) async {
        if (message is GetTokenRequest) {
          try {
            _replyPort.send((token: await getAuthToken(), error: null));
          } catch (e) {
            _replyPort.send((token: null, error: e));
          }
        } else if (message is SendPort) {
          _replyPort = message;
        }
      },
    );
  }

  @override
  @mustCallSuper
  Future<void> close() async {
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

  static Future<Client> initClient(
    ClientParams params,
    SendPort? sendPort,
  ) async {
    AuthToken? token;
    final receivePort = ReceivePort();
    sendPort?.send(receivePort.sendPort);
    final tokenStream =
        receivePort
            .where((e) => e is GetTokenResponse)
            .cast<GetTokenResponse>()
            .asBroadcastStream();

    return buildClient(
      params: params,
      getToken: () async {
        if (token != null && DateTime.timestamp().isBefore(token!.expiresAt)) {
          return token!.accessToken;
        } else {
          sendPort?.send(GetTokenRequest());
          final response = await tokenStream.first.timeout(
            params.requestTimeout,
          );
          if (response.token != null) {
            token = response.token;
            return token!.accessToken;
          } else {
            throw Exception(response.error);
          }
        }
      },
    );
  }
}
