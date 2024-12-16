import 'dart:async';
import 'package:ferry/ferry.dart'
    show Client, OperationRequest, OperationResponse;

import 'consts.dart';
import 'tentura_api_base.dart';
import 'client/gql_web_client.dart';

class TenturaApi extends TenturaApiBase {
  TenturaApi({
    required super.apiUrlBase,
    super.jwtExpiresIn,
    super.storagePath,
    super.isDebugMode,
    super.userAgent,
  });

  late final Client _gqlClient;

  @override
  Future<void> init() async {
    _gqlClient = await buildClient(
      serverUrl: apiUrlBase + pathGraphQLEndpoint,
      getToken: getToken,
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
