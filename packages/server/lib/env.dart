import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'consts.dart';

@singleton
class Env {
  Env({bool? isDebugModeOn, String? publicKey, String? privateKey})
    : kDebugMode = isDebugModeOn ?? _environment['DEBUG_MODE'] == 'true',
      publicKey = EdDSAPublicKey.fromPEM(
        (publicKey ?? kJwtPublicKey).replaceAll(r'\n', '\n'),
      ),
      privateKey = EdDSAPrivateKey.fromPEM(
        (privateKey ?? kJwtPrivateKey).replaceAll(r'\n', '\n'),
      );

  @factoryMethod
  Env.fromSystem() : this();

  final bool kDebugMode;

  final EdDSAPublicKey publicKey;

  final EdDSAPrivateKey privateKey;

  static final _environment = Platform.environment;
}
