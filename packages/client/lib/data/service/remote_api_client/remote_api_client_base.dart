import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ferry/ferry.dart'
    show
        Cache,
        Client,
        FetchPolicy,
        Link,
        MemoryStore,
        OperationRequest,
        OperationResponse,
        OperationType;
import 'package:gql_exec/gql_exec.dart';
import 'package:flutter/foundation.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_error_link/gql_error_link.dart';
import 'package:gql_dedupe_link/gql_dedupe_link.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';

import 'package:tentura_root/consts.dart';

import 'exception.dart';
import 'auth_link.dart';

typedef ClientParams = ({String serverUrl, String userAgent});

typedef AuthToken = ({String id, String accessToken, DateTime expiresAt});

typedef KeyPair = ({EdDSAPrivateKey privateKey, EdDSAPublicKey publicKey});

abstract base class RemoteApiClientBase {
  RemoteApiClientBase({
    required this.userAgent,
    required this.apiUrlBase,
    required this.jwtExpiresIn,
    required this.requestTimeout,
  });

  final String userAgent;
  final String apiUrlBase;
  final Duration jwtExpiresIn;
  final Duration requestTimeout;

  final _httpClient = http.Client();

  KeyPair? _keyPair;

  AuthToken? _jwt;

  bool _tokenLocked = false;

  bool get hasValidToken =>
      _jwt != null && DateTime.timestamp().isBefore(_jwt!.expiresAt);

  ClientParams get params => (
    serverUrl: apiUrlBase + kPathGraphQLEndpoint,
    userAgent: userAgent,
  );

  String get authRequestToken =>
      JWT({'pk': base64Encode(_keyPair!.publicKey.key.bytes)}).sign(
        _keyPair!.privateKey,
        algorithm: JWTAlgorithm.EdDSA,
        expiresIn: jwtExpiresIn,
      );

  // ignore: avoid_setters_without_getters //
  set authToken(AuthToken? value) {
    _tokenLocked = false;
    _jwt = value;
  }

  Future<void> init();

  @mustCallSuper
  Future<void> close() async {
    _httpClient.close();
  }

  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
      OperationRequest<TData, TVars>,
    )?
    forward,
  ]);

  void setKeyPairFromSeed(String? seed) {
    _jwt = null;
    if (seed == null) {
      _keyPair = null;
    } else {
      final privateKey = newKeyFromSeed(base64Decode(seed));
      _keyPair = (
        privateKey: EdDSAPrivateKey(privateKey.bytes),
        publicKey: EdDSAPublicKey(public(privateKey).bytes),
      );
    }
  }

  Future<String> getAuthToken() async {
    if (hasValidToken) {
      return _jwt!.accessToken;
    }
    if (!_tokenLocked) {
      await _fetchJWT();
      return _jwt!.accessToken;
    }
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration(milliseconds: 100 + 100 * i));
      if (!_tokenLocked && hasValidToken) {
        return _jwt!.accessToken;
      }
    }
    throw TimeoutException('Timeout while refreshing token!');
  }

  Future<http.Response> httpPut(
    Uri url, {
    Map<String, String>? headers,
    bool withAuthToken = true,
    Object? body,
  }) async => _httpClient.put(
    url,
    body: body,
    headers: {
      if (withAuthToken) kHeaderAuthorization: 'Bearer ${await getAuthToken()}',
      kHeaderUserAgent: userAgent,
      ...?headers,
    },
  );

  Future<void> _fetchJWT() async {
    if (_keyPair == null) {
      throw const AuthenticationNoKeyException();
    }
    try {
      _tokenLocked = true;
      final response = await _httpClient
          .post(
            Uri.parse(apiUrlBase + kPathGraphQLEndpoint),
            headers: {
              kHeaderContentType: kContentApplicationJson,
              kHeaderUserAgent: userAgent,
            },
            body: jsonEncode({
              'query': _fetchTokenQuery,
              'variables': {'authRequestToken': authRequestToken},
            }),
          )
          .timeout(requestTimeout);

      if (response.statusCode != 200) {
        throw AuthenticationHttpException(response.reasonPhrase);
      } else {
        final body = jsonDecode(response.body) as Map;
        _jwt = (
          id: body['subject'] as String,
          accessToken: body['access_token'] as String,
          expiresAt: DateTime.timestamp().add(
            Duration(seconds: body['expires_in'] as int),
          ),
        );
      }
    } finally {
      _tokenLocked = false;
    }
  }

  static const _fetchTokenQuery = r'''
mutation SignIn($authRequestToken: String!) {
  signIn(authRequestToken: $authRequestToken) {
    access_token
    expires_in
    subject
  }
}
''';

  static Future<Client> buildClient({
    required ClientParams params,
    required Future<String?> Function() getToken,
  }) async => Client(
    cache: Cache(store: MemoryStore()),
    defaultFetchPolicies: {OperationType.query: FetchPolicy.NoCache},
    link: Link.from([
      DedupeLink(),

      AuthLink(getToken),

      ErrorLink(
        onException: (request, forward, exception) {
          log(exception.toString());
          return null;
        },
        onGraphQLError: (request, forward, response) {
          log(response.errors.toString());
          return null;
        },
      ),

      Link.split(
        (Request request) =>
            request.operation.getOperationType() == OperationType.subscription,
        TransportWebSocketLink(
          TransportWsClientOptions(
            connectionParams:
                () async => {
                  'headers': {
                    kHeaderUserAgent: params.userAgent,
                    kHeaderContentType: kContentApplicationJson,
                    kHeaderAuthorization: 'Bearer ${await getToken()}',
                  },
                },

            socketMaker: WebSocketMaker.url(
              () =>
                  Uri.parse(
                    params.serverUrl,
                  ).replace(port: 443, scheme: 'wss').toString(),
            ),
            shouldRetry: (_) => true,
            log: log,
          ),
        ),
        HttpLink(
          params.serverUrl,
          defaultHeaders: {
            kHeaderAccept: kContentApplicationJson,
            kHeaderUserAgent: params.userAgent,
          },
        ),
      ),
    ]),
  );
}
