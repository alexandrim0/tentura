import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';

import '../consts.dart';
import '../exception.dart';
import '../client/message.dart';
import '../jwt.dart';

/// Set KeyPair before fetchJWT
abstract class TokenServiceBase {
  static const _jwtHeader = 'eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.';

  TokenServiceBase({
    required this.apiUrlBase,
    this.jwtExpiresIn = const Duration(minutes: 1),
  });

  final String apiUrlBase;
  final Duration jwtExpiresIn;

  KeyPair? keyPair;

  JWT _jwt = jwtEmpty;

  bool _tokenLocked = false;

  bool get hasValidToken => DateTime.timestamp().isBefore(_jwt.expiresAt);

  /// Generate and set new KeyPair and returns its seed
  Future<String> setNewKeyPair();

  Future<void> setKeyPairFromSeed(String seed);

  Future<GetTokenResponse> getToken() async {
    if (hasValidToken) return GetTokenResponse(value: _jwt.accessToken);

    if (!_tokenLocked) {
      try {
        await signIn();
        return GetTokenResponse(value: _jwt.accessToken);
      } catch (e) {
        return GetTokenResponse(error: e);
      }
    }

    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!_tokenLocked && hasValidToken) {
        return GetTokenResponse(value: _jwt.accessToken);
      }
    }

    return GetTokenResponse(
      error: TimeoutException('Timeout while refreshing token!'),
    );
  }

  /// Returns id of actual account
  Future<String> signIn() async {
    _jwt = jwtEmpty;
    _tokenLocked = true;
    try {
      _jwt = await _fetchJWT(pathLogin);
    } finally {
      _tokenLocked = false;
    }
    return _jwt.id;
  }

  /// Returns id of actual account
  Future<String> signUp() async {
    _jwt = jwtEmpty;
    _tokenLocked = true;
    try {
      _jwt = await _fetchJWT(pathRegister);
    } finally {
      _tokenLocked = false;
    }
    return _jwt.id;
  }

  // TBD: invalidate jwt on remote server also
  Future<void> signOut() async {
    keyPair = null;
    _jwt = jwtEmpty;
    _tokenLocked = false;
  }

  Future<JWT> _fetchJWT(String path) async {
    final response = await post(
      Uri.parse(apiUrlBase + path),
      headers: {
        'Authorization': 'Bearer ${_createAuthRequestToken()}',
      },
    );
    switch (response.statusCode) {
      case 200:
        final body = jsonDecode(response.body) as Map;
        return (
          id: body['subject'] as String,
          accessToken: body['access_token'] as String,
          expiresAt: DateTime.timestamp()
              .add(Duration(seconds: body['expires_in'] as int)),
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
  }

  String _createAuthRequestToken() {
    final now = DateTime.timestamp().millisecondsSinceEpoch ~/ 1000;
    final body = base64UrlEncode(utf8.encode(jsonEncode({
      'pk': base64UrlEncode(keyPair!.publicKey.bytes).replaceAll('=', ''),
      'iat': now,
      'exp': now + jwtExpiresIn.inSeconds,
      // TBD: uuid for jwt invalidation on logout
      'jti': '',
    }))).replaceAll('=', '');
    final signature = base64UrlEncode(sign(
      keyPair!.privateKey,
      Uint8List.fromList(utf8.encode(_jwtHeader + body)),
    )).replaceAll('=', '');
    return '$_jwtHeader$body.$signature';
  }
}
