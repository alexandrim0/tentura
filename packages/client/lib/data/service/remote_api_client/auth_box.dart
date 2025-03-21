import 'dart:convert';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tentura/consts.dart';

part 'auth_box.freezed.dart';

typedef AuthToken = ({String userId, String accessToken, DateTime expiresAt});

@freezed
class AuthBox with _$AuthBox {
  const factory AuthBox({
    required EdDSAPublicKey publicKey,
    required EdDSAPrivateKey privateKey,
    AuthToken? authToken,
  }) = _AuthBox;

  factory AuthBox.fromSeed(String seed) {
    final privateKey = newKeyFromSeed(base64Decode(seed));
    return AuthBox(
      privateKey: EdDSAPrivateKey(privateKey.bytes),
      publicKey: EdDSAPublicKey(public(privateKey).bytes),
    );
  }

  const AuthBox._();

  bool get hasValidToken =>
      authToken != null && DateTime.timestamp().isBefore(authToken!.expiresAt);

  String get authRequestToken =>
      JWT({'pk': base64UrlEncode(publicKey.key.bytes)}).sign(
        privateKey,
        algorithm: JWTAlgorithm.EdDSA,
        expiresIn: const Duration(seconds: kAuthJwtExpiresIn),
      );
}
