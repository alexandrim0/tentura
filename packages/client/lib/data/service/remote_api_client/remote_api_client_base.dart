import 'dart:async';
import 'package:ferry/ferry.dart' show OperationRequest, OperationResponse;
import 'package:flutter/foundation.dart';

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
    required this.requestTimeout,
    required this.userAgent,
  });

  final String userAgent;
  final String apiEndpointUrl;
  final Duration requestTimeout;
  final Duration authJwtExpiresIn;

  bool _tokenLocked = false;

  AuthBox? _authBox;

  /// Returns Auth Request JWT
  @mustCallSuper
  Future<String?> setAuth({
    required String seed,
    required AuthTokenFetcher authTokenFetcher,
    AuthRequestIntent? returnAuthRequestToken,
  }) async {
    _tokenLocked = false;
    _authBox = AuthBox.fromSeed(seed: seed, authTokenFetcher: authTokenFetcher);
    return returnAuthRequestToken == null
        ? null
        : _authBox!.getAuthRequestToken(returnAuthRequestToken);
  }

  @mustCallSuper
  Future<void> close() async {
    _authBox = null;
    _tokenLocked = false;
  }

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

  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
      OperationRequest<TData, TVars>,
    )?
    forward,
  ]);
}
