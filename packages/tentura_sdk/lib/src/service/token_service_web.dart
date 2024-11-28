import 'dart:async';
import 'dart:convert';
import 'package:ed25519_edwards/ed25519_edwards.dart';

import 'token_service_base.dart';

/// Set KeyPair before fetchJWT
class TokenService extends TokenServiceBase {
  TokenService({
    required super.apiUrlBase,
    super.jwtExpiresIn = const Duration(minutes: 1),
  });

  /// Generate and set new KeyPair and returns its seed
  @override
  Future<String> setNewKeyPair() async {
    keyPair = generateKey();
    return base64UrlEncode(seed(keyPair!.privateKey));
  }

  @override
  Future<void> setKeyPairFromSeed(String seed) async {
    final privateKey = newKeyFromSeed(base64Decode(seed));
    keyPair = KeyPair(privateKey, public(privateKey));
  }
}
