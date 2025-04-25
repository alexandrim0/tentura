import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'consts.dart';

@singleton
class Env {
  Env({
    bool? isDebugModeOn,
    bool? isNeedInvite,
    Duration? invitationTTL,
    String? publicKey,
    String? privateKey,
  }) : isDebugModeOn = isDebugModeOn ?? _environment['DEBUG_MODE'] == 'true',
       isNeedInvite = isNeedInvite ?? _environment['NEED_INVITE'] == 'true',
       invitationTTL =
           invitationTTL ??
           Duration(
             hours:
                 int.tryParse(_environment['INVITATION_TTL'] ?? '') ??
                 kInvitationDefaultTTL,
           ),
       publicKey = EdDSAPublicKey.fromPEM(
         (publicKey ?? kJwtPublicKey).replaceAll(r'\n', '\n'),
       ),
       privateKey = EdDSAPrivateKey.fromPEM(
         (privateKey ?? kJwtPrivateKey).replaceAll(r'\n', '\n'),
       );

  @factoryMethod
  Env.fromSystem() : this();

  final bool isDebugModeOn;

  final bool isNeedInvite;

  final Duration invitationTTL;

  final EdDSAPublicKey publicKey;

  final EdDSAPrivateKey privateKey;

  static final _environment = Platform.environment;
}
