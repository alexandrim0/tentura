import 'dart:async';
import 'dart:isolate';
import 'package:ferry/ferry.dart' show OperationRequest, OperationResponse;
import 'package:ferry/ferry_isolate.dart';

import 'consts.dart';
import 'client/message.dart';
import 'client/gql_client.dart';
import 'tentura_api_base.dart';

class TenturaApi extends TenturaApiBase {
  TenturaApi({
    required super.apiUrlBase,
    super.jwtExpiresIn = const Duration(minutes: 1),
    super.userAgent = 'Tentura client',
    super.storagePath = '',
    super.isDebugMode = false,
  });

  late final SendPort _replyPort;

  late final IsolateClient _gqlClient;

  @override
  Future<void> init() async {
    _gqlClient = await IsolateClient.create(
      buildClient,
      params: (
        userAgent: userAgent,
        isDebugMode: isDebugMode,
        storagePath: storagePath,
        serverUrl: apiUrlBase + pathGraphQLEndpoint,
      ),
      messageHandler: (message) async => switch (message) {
        final InitMessage m => _replyPort = m.replyPort,
        final GetTokenRequest _ => _replyPort.send(await getToken()),
        _ => null,
      },
    );
  }

  @override
  Future<void> close() async {
    await _gqlClient.dispose();
  }

  @override
  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
            OperationRequest<TData, TVars>)?
        forward,
  ]) =>
      _gqlClient.request(request);
}
