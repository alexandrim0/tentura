import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart'
    show ConnectionSettings, Endpoint, PoolSettings, SslMode;

import 'consts.dart';

export 'consts.dart';

class Env {
  Env({
    // Common
    String? environment,
    bool? isDebugModeOn,
    int? workersCount,
    Uri? serverUri,
    bool? printEnv,
    bool? renderSharedPreview,
    // Auth
    bool? isNeedInvite,
    Duration? jwtExpiresIn,
    Duration? invitationTTL,
    String? publicKey,
    String? privateKey,
    // Web server
    String? bindAddress,
    int? listenPort,
    // Postgres
    String? pgHost,
    int? pgPort,
    String? pgDatabase,
    String? pgUsername,
    String? pgPassword,
    int? maxConnectionAge,
    int? maxConnectionCount,
    // S3 storage
    String? kS3AccessKey,
    String? kS3SecretKey,
    String? kS3Endpoint,
    String? kS3Bucket,
    // Task Worker
    Duration? taskOnEmptyDelay,
    // Meritrank service
    Duration? meritrankCalculateTimeout,
    // Chat
    Duration? chatPollingInterval,
  }) : // Common
       printEnv = printEnv ?? _env['PRINT_ENV'] == 'true',
       isDebugModeOn = isDebugModeOn ?? _env['DEBUG_MODE'] == 'true',
       environment = environment ?? _env['ENVIRONMENT'] ?? Environment.prod,
       serverUri = serverUri ?? Uri.dataFromString(kServerName),
       renderSharedPreview =
           renderSharedPreview ?? _env['RENDER_SHARED_PREVIEW'] == 'true',
       workersCount =
           workersCount ??
           int.tryParse(_env['WORKERS_COUNT'] ?? '') ??
           Platform.numberOfProcessors,
       // Auth
       invitationTTL = invitationTTL ?? kInvitationTTL,
       jwtExpiresIn = jwtExpiresIn ?? const Duration(seconds: kJwtExpiresIn),
       isNeedInvite = isNeedInvite ?? _env['NEED_INVITE'] == 'true',
       publicKey = EdDSAPublicKey.fromPEM(
         (publicKey ?? _env['JWT_PUBLIC_PEM'] ?? kJwtPublicKey).replaceAll(
           r'\n',
           '\n',
         ),
       ),
       privateKey = EdDSAPrivateKey.fromPEM(
         (privateKey ?? _env['JWT_PRIVATE_PEM'] ?? kJwtPrivateKey).replaceAll(
           r'\n',
           '\n',
         ),
       ),
       // Web server
       bindAddress = bindAddress ?? _env['HOST'] ?? '0.0.0.0',
       listenPort = listenPort ?? int.tryParse(_env['PORT'] ?? '') ?? 2080,
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
       taskOnEmptyDelay =
           taskOnEmptyDelay ??
           Duration(seconds: int.tryParse(_env['TASK_DELAY'] ?? '') ?? 1),
       // S3 storage
       kS3AccessKey = kS3AccessKey ?? _env['S3_ACCESS_KEY'] ?? '',
       kS3SecretKey = kS3SecretKey ?? _env['S3_SECRET_KEY'] ?? '',
       kS3Endpoint = kS3Endpoint ?? _env['S3_ENDPOINT'] ?? '',
       kS3Bucket = kS3Bucket ?? _env['S3_BUCKET'] ?? '',
       // Meritrank service
       meritrankCalculateTimeout =
           meritrankCalculateTimeout ??
           Duration(
             minutes: int.tryParse(_env['MR_CALCULATE_TIMEOUT'] ?? '') ?? 10,
           ),
       // Chat
       chatPollingInterval =
           chatPollingInterval ??
           Duration(
             seconds: int.tryParse(_env['CHAT_POLLING_INTERVAL'] ?? '') ?? 1,
           )
  //
  {
    _printEnvInfo();
  }

  Env.dev() : this(environment: Environment.dev);

  Env.prod() : this(environment: Environment.prod);

  Env.test()
    : this(
        environment: Environment.test,
        renderSharedPreview: true,
        isDebugModeOn: true,
        workersCount: 1,
        printEnv: true,
      );

  // Common
  final bool isDebugModeOn;

  final String environment;

  final bool printEnv;

  final Uri serverUri;

  final int workersCount;

  final bool renderSharedPreview;

  late final isolatesCount = isDebugModeOn ? 1 : workersCount;

  // Auth
  final bool isNeedInvite;

  final Duration jwtExpiresIn;

  final Duration invitationTTL;

  final EdDSAPublicKey publicKey;

  final EdDSAPrivateKey privateKey;

  // Web server
  final String bindAddress;

  final int listenPort;

  // Task Worker
  final Duration taskOnEmptyDelay;

  // S3 settings
  final String kS3AccessKey;

  final String kS3SecretKey;

  final String kS3Endpoint;

  final String kS3Bucket;

  late final kIsRemoteStorageEnabled =
      kS3Endpoint.isNotEmpty &&
      kS3Bucket.isNotEmpty &&
      kS3AccessKey.isNotEmpty &&
      kS3SecretKey.isNotEmpty;

  // Postgres
  final String pgHost;

  final int pgPort;

  final String pgDatabase;

  final String pgUsername;

  final String pgPassword;

  final int pgMaxConnectionAge;

  final int pgMaxConnectionCount;

  final pgEndpointSettings = const ConnectionSettings(sslMode: SslMode.disable);

  late final pgPoolSettings = PoolSettings(
    maxConnectionAge: Duration(seconds: pgMaxConnectionAge),
    maxConnectionCount: pgMaxConnectionCount,
    sslMode: pgEndpointSettings.sslMode,
  );

  late final pgEndpoint = Endpoint(
    host: pgHost,
    port: pgPort,
    database: pgDatabase,
    username: pgUsername,
    password: pgPassword,
  );

  // Meritrank service
  final Duration meritrankCalculateTimeout;

  final Duration chatPollingInterval;

  void _printEnvInfo() {
    if (printEnv) {
      print('Debug Mode: [$isDebugModeOn]');
      print('Need Invitation: [$isNeedInvite]');
      print('Invitation TTL: [${invitationTTL.inHours}]');
    }
  }

  static final _env = Platform.environment;

  // JWT
  // This keys needed for testing purposes only!
  // You should not use this keys on public server!
  // Be sure if you set your own secure keys!
  //
  static const kJwtPublicKey = '''
-----BEGIN PUBLIC KEY-----
MCowBQYDK2VwAyEA2CmIb3Ho2eb6m8WIog6KiyzCY05sbyX04PiGlH5baDw=
-----END PUBLIC KEY-----
''';

  static const kJwtPrivateKey = '''
-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEIN3rCo3wCksyxX4qBYAC1vFr51kx/Od78QVrRLOV1orF
-----END PRIVATE KEY-----
''';
}
