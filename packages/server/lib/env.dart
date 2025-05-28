import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'consts.dart';

@singleton
class Env {
  Env({
    bool? printEnv,
    bool? isDebugModeOn,
    bool? isNeedInvite,
    Duration? invitationTTL,
    String? publicKey,
    String? privateKey,
    String? pgHost,
    int? pgPort,
    String? pgDatabase,
    String? pgUsername,
    String? pgPassword,
    int? maxConnectionAge,
    int? maxConnectionCount,
  }) : printEnv = printEnv ?? _env['PRINT_ENV'] == 'true',
       isDebugModeOn = isDebugModeOn ?? _env['DEBUG_MODE'] == 'true',
       isNeedInvite = isNeedInvite ?? _env['NEED_INVITE'] == 'true',
       invitationTTL =
           invitationTTL ??
           Duration(
             hours:
                 int.tryParse(environment['INVITATION_TTL'] ?? '') ??
                 kInvitationDefaultTTL,
           ),
       publicKey = EdDSAPublicKey.fromPEM(
         (publicKey ?? kJwtPublicKey).replaceAll(r'\n', '\n'),
       ),
       privateKey = EdDSAPrivateKey.fromPEM(
         (privateKey ?? kJwtPrivateKey).replaceAll(r'\n', '\n'),
       ),
       // Postgres
       pgHost = pgHost ?? _env['POSTGRES_HOST'] ?? 'postgres',
       pgPort = pgPort ?? int.tryParse(_env['POSTGRES_PORT'] ?? '') ?? 5432,
       pgDatabase = pgDatabase ?? _env['POSTGRES_DBNAME'] ?? 'postgres',
       pgUsername = pgUsername ?? _env['POSTGRES_USERNAME'] ?? 'postgres',
       pgPassword = pgPassword ?? _env['POSTGRES_PASSWORD'] ?? 'password',
       pgMaxConnectionAge =
           maxConnectionAge ??
           int.tryParse(_env['POSTGRES_MAXCONNAGE'] ?? '') ??
           600,
       pgMaxConnectionCount =
           maxConnectionCount ??
           int.tryParse(_env['POSTGRES_MAXCONN'] ?? '') ??
           25,
       // Task Worker
       taskOnEmptyDelay = Duration(
         seconds: int.tryParse(_env['TASK_DELAY'] ?? '') ?? 1,
       );

  @factoryMethod
  Env.fromSystem() : this();

  final bool isDebugModeOn;

  final bool printEnv;

  final bool isNeedInvite;

  final Duration invitationTTL;

  final EdDSAPublicKey publicKey;

  final EdDSAPrivateKey privateKey;

  // Postgres
  final String pgHost;

  final int pgPort;

  final String pgDatabase;

  final String pgUsername;

  final String pgPassword;

  final int pgMaxConnectionAge;

  final int pgMaxConnectionCount;

  // Task Worker
  final Duration taskOnEmptyDelay;

  void printEnvInfo() {
    if (printEnv) {
      print('Debug Mode: [$isDebugModeOn]');
      print('Need Invitation: [$isNeedInvite]');
      print('Invitation TTL: [${invitationTTL.inHours}]');
    }
  }

  static final _env = Platform.environment;
}
