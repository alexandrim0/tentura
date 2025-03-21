import 'dart:async';
import 'package:ferry/ferry.dart' show OperationResponse;
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';

import 'remote_api_client/auth_box.dart';
import 'remote_api_client/exception.dart';
// import 'remote_api_client/remote_api_client_web.dart';
import 'remote_api_client/remote_api_client_native.dart'
    if (dart.library.js_interop) 'remote_api_client/remote_api_client_web.dart';

export 'package:ferry/ferry.dart'
    show DataSource, FetchPolicy, OperationResponse;
export 'package:gql_exec/gql_exec.dart' show Context, HttpLinkHeaders;

export 'remote_api_client/auth_box.dart';

typedef AuthTokenFetcher =
    Future<AuthToken> Function(
      RemoteApiService remoteApiService,
      String authRequestToken,
    );

@singleton
final class RemoteApiService extends RemoteApiClient {
  @FactoryMethod(preResolve: true)
  static Future<RemoteApiService> create() async {
    final api = RemoteApiService();
    await api.init();
    return api;
  }

  RemoteApiService({
    super.userAgent = kUserAgent,
    super.apiEndpointUrl = kServerName + kPathGraphQLEndpoint,
    super.authJwtExpiresIn = const Duration(seconds: kAuthJwtExpiresIn),
    super.requestTimeout = const Duration(seconds: kRequestTimeout),
  });

  late AuthTokenFetcher authTokenFetcher;

  bool _tokenLocked = false;

  AuthBox? _authBox;

  String? get authRequestToken => _authBox?.authRequestToken;

  @override
  @disposeMethod
  Future<void> close() async {
    await super.close();
  }

  /// Returns Auth Request JWT
  String? setAuth(String seed, {bool returnAuthRequestToken = false}) {
    _tokenLocked = false;
    _authBox = AuthBox.fromSeed(seed);
    return returnAuthRequestToken ? _authBox?.authRequestToken : null;
  }

  void dropAuth() {
    _authBox = null;
    _tokenLocked = false;
  }

  @override
  Future<AuthToken> getAuthToken() async {
    final authBox = _authBox ?? (throw const AuthenticationNoKeyException());
    if (authBox.hasValidToken) {
      return authBox.authToken!;
    }
    if (_tokenLocked) {
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration(milliseconds: 100 + 100 * i));
        if (!_tokenLocked && (_authBox?.hasValidToken ?? false)) {
          return _authBox!.authToken!;
        }
      }
      throw TimeoutException('Timeout while refreshing token!');
    } else {
      _tokenLocked = true;
      try {
        final authToken = await authTokenFetcher(
          this,
          authBox.authRequestToken,
        );
        _authBox = authBox.copyWith(authToken: authToken);
        return authToken;
      } finally {
        _tokenLocked = false;
      }
    }
  }
}

extension ErrorHandler<TData, TVars> on OperationResponse<TData, TVars> {
  TData dataOrThrow({String? label}) {
    if (hasErrors) {
      throw GraphQLException(
        error: linkException ?? graphqlErrors,
        label: label,
      );
    }
    if (data == null) throw GraphQLNoDataException(label: label);

    return data!;
  }
}
