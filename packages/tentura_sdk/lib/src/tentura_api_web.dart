import 'dart:async';
import 'package:ferry/ferry.dart'
    show Client, OperationRequest, OperationResponse;

import 'tentura_api_base.dart';
import 'gql_client.dart';

base class TenturaApi extends TenturaApiBase {
  TenturaApi({
    required super.apiUrlBase,
    required super.jwtExpiresIn,
    required super.requestTimeout,
    required super.userAgent,
  });

  late final Client _gqlClient;

  @override
  Future<void> init() async {
    _gqlClient = await buildClient(params: params, getToken: getToken);
  }

  @override
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
