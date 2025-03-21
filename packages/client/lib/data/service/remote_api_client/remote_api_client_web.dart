import 'dart:async';
import 'package:ferry/ferry.dart'
    show Client, OperationRequest, OperationResponse;
import 'package:flutter/foundation.dart';

import 'build_client.dart';
import 'remote_api_client_base.dart';

abstract base class RemoteApiClient extends RemoteApiClientBase {
  RemoteApiClient({
    required super.apiEndpointUrl,
    required super.authJwtExpiresIn,
    required super.requestTimeout,
    required super.userAgent,
  });

  late final Client _gqlClient;

  @override
  Future<void> init() async {
    _gqlClient = await buildClient(
      params: (
        apiEndpointUrl: apiEndpointUrl,
        userAgent: userAgent,
        requestTimeout: requestTimeout,
      ),
      getToken: () async => (await getAuthToken()).accessToken,
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
}
