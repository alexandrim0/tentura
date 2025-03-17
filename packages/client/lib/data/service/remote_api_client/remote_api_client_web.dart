import 'dart:async';
import 'package:ferry/ferry.dart'
    show Client, OperationRequest, OperationResponse;

import 'remote_api_client_base.dart';

base class RemoteApiClient extends RemoteApiClientBase {
  RemoteApiClient({
    required super.apiUrlBase,
    required super.jwtExpiresIn,
    required super.requestTimeout,
    required super.userAgent,
  });

  late final Client _gqlClient;

  @override
  Future<void> init() async {
    _gqlClient = await RemoteApiClientBase.buildClient(
      params: params,
      getToken: getAuthToken,
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
}
