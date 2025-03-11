import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:ferry/ferry.dart' show OperationRequest, OperationResponse;
import 'package:ed25519_edwards/ed25519_edwards.dart';

import 'package:tentura_root/consts.dart';

import 'exception.dart';
import 'gql_client.dart';

typedef JWT = ({String id, String accessToken, DateTime expiresAt});

abstract base class TenturaApiBase {
  TenturaApiBase({
    required this.userAgent,
    required this.apiUrlBase,
    required this.jwtExpiresIn,
    required this.requestTimeout,
  });

  final String userAgent;
  final String apiUrlBase;
  final Duration jwtExpiresIn;
  final Duration requestTimeout;

  KeyPair? _keyPair;

  JWT? _jwt;

  bool _tokenLocked = false;

  bool get hasValidToken =>
      _jwt != null && DateTime.timestamp().isBefore(_jwt!.expiresAt);

  ClientParams get params => (
    serverUrl: apiUrlBase + kPathGraphQLEndpoint,
    userAgent: userAgent,
  );

  Future<void> init();

  Future<void> close();

  Future<void> uploadImage({
    required Uint8List image,
    required String id,
  }) async => put(
    Uri.parse('$apiUrlBase/$kPathImageUpload?id=$id'),
    headers: {
      kHeaderContentType: kContentTypeJpeg,
      kHeaderAuthorization: 'Bearer ${await getToken()}',
    },
    body: image,
  );

  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
      OperationRequest<TData, TVars>,
    )?
    forward,
  ]);

  Future<String> getToken() async {
    if (hasValidToken) {
      return _jwt!.accessToken;
    }
    if (!_tokenLocked) {
      await _fetchJWT(kPathLogin);
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

  /// Returns id of actual account
  Future<String> signIn(String seed) async {
    _setKeyPairFromSeed(seed);
    await _fetchJWT(kPathLogin);
    return _jwt!.id;
  }

  /// Returns id of actual account
  Future<String> signUp(String seed) async {
    _setKeyPairFromSeed(seed);
    try {
      _tokenLocked = true;
      await _fetchJWT(kPathRegister);
      return _jwt!.id;
    } finally {
      _tokenLocked = false;
    }
  }

  // TBD: invalidate jwt on remote server also
  Future<void> signOut() async {
    _jwt = null;
    _keyPair = null;
    _tokenLocked = false;
  }

  @visibleForTesting
  String createAuthRequestToken(KeyPair keyPair) {
    final now = DateTime.timestamp().millisecondsSinceEpoch ~/ 1000;
    final body = base64UrlEncode(
      utf8.encode(
        jsonEncode({
          'pk': base64UrlEncode(keyPair.publicKey.bytes).replaceAll('=', ''),
          'exp': now + jwtExpiresIn.inSeconds,
          'iat': now,
        }),
      ),
    ).replaceAll('=', '');
    final token = 'eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.$body';
    final signature = base64UrlEncode(
      sign(keyPair.privateKey, Uint8List.fromList(utf8.encode(token))),
    ).replaceAll('=', '');
    return '$token.$signature';
  }

  void _setKeyPairFromSeed(String seed) {
    final privateKey = newKeyFromSeed(base64Decode(seed));
    _keyPair = KeyPair(privateKey, public(privateKey));
  }

  Future<void> _fetchJWT(String path) async {
    if (_keyPair == null) {
      throw const AuthenticationNoKeyException();
    }
    try {
      _tokenLocked = true;
      final response = await post(
        Uri.parse(apiUrlBase + path),
        headers: {
          'Authorization': 'Bearer ${createAuthRequestToken(_keyPair!)}',
          'User-Agent': userAgent,
        },
      ).timeout(requestTimeout);
      switch (response.statusCode) {
        case 200:
          final body = jsonDecode(response.body) as Map;
          _jwt = (
            id: body['subject'] as String,
            accessToken: body['access_token'] as String,
            expiresAt: DateTime.timestamp().add(
              Duration(seconds: body['expires_in'] as int),
            ),
          );
        case 401:
          throw const AuthenticationFailedException();
        case 404:
          throw const AuthenticationNotFoundException();
        case 409:
          throw const AuthenticationDuplicatedException();
        case 502:
          throw const AuthenticationServerException();
        default:
          throw AuthenticationHttpException(response.reasonPhrase);
      }
    } finally {
      _tokenLocked = false;
    }
  }
}
