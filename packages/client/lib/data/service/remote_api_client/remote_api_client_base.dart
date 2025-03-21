import 'dart:async';
import 'package:ferry/ferry.dart' show OperationRequest, OperationResponse;

import 'auth_box.dart';

abstract class RemoteApiClientBase {
  RemoteApiClientBase({
    required this.authJwtExpiresIn,
    required this.apiEndpointUrl,
    required this.requestTimeout,
    required this.userAgent,
  });

  final String userAgent;
  final String apiEndpointUrl;
  final Duration requestTimeout;
  final Duration authJwtExpiresIn;

  Future<void> init();

  Future<void> close();

  Future<AuthToken> getAuthToken();

  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
      OperationRequest<TData, TVars>,
    )?
    forward,
  ]);
}
