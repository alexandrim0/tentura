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
    int? listenWebPort,
    bool? isPongEnabled,

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
    int? chatDefaultBatchSize,
    Duration? chatStatusOfflineAfterDelay,

    // Firebase
    String? fbAppId,
    String? fbApiKey,
    String? fbSenderId,
    String? fbProjectId,
    String? fbAuthDomain,
    String? fbStorageBucket,
    String? fbClientEmail,
    String? fbPrivateKey,
    Duration? fbAccessTokenExpiresIn,
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
       listenWebPort =
           listenWebPort ?? int.tryParse(_env['PORT'] ?? '') ?? 2080,
       isPongEnabled = isPongEnabled ?? _env['PONG_ENABLED'] != 'false',

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
           ),
       chatDefaultBatchSize =
           chatDefaultBatchSize ??
           int.tryParse(_env['CHAT_BATCH_SIZE'] ?? '') ??
           10,
       chatStatusOfflineAfterDelay =
           chatStatusOfflineAfterDelay ??
           Duration(
             seconds:
                 int.tryParse(_env['CHAT_OFFLINE_DELAY'] ?? '') ??
                 kUserOfflineAfterSeconds,
           ),

       // Firebase
       fbAppId = fbAppId ?? _env['FB_APP_ID'] ?? '',
       fbApiKey = fbApiKey ?? _env['FB_API_KEY'] ?? '',
       fbSenderId = fbSenderId ?? _env['FB_SENDER_ID'] ?? '',
       fbProjectId = fbProjectId ?? _env['FB_PROJECT_ID'] ?? '',
       fbAuthDomain = fbAuthDomain ?? _env['FB_AUTH_DOMAIN'] ?? '',
       fbStorageBucket = fbStorageBucket ?? _env['FB_STORAGE_BUCKET'] ?? '',
       fbClientEmail = fbClientEmail ?? _env['FB_CLIENT_EMAIL'] ?? '',
       fbAccessTokenExpiresIn =
           fbAccessTokenExpiresIn ?? const Duration(hours: 1),
       fbPrivateKey = RSAPrivateKey(
         (fbPrivateKey ?? _env['FB_PRIVATE_KEY'] ?? kFbPrivateKey).replaceAll(
           r'\n',
           '\n',
         ),
       )
  //
  {
    _printEnvInfo();
  }

  Env.dev()
    : this(
        environment: Environment.dev,
        isDebugModeOn: true,
        workersCount: 1,
        printEnv: true,
      );

  Env.prod()
    : this(
        environment: Environment.prod,
      );

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

  final int listenWebPort;

  final bool isPongEnabled;

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

  final pgEndpointSettings = const ConnectionSettings(
    sslMode: SslMode.disable,
  );

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

  // Chat
  final Duration chatPollingInterval;

  final int chatDefaultBatchSize;

  final Duration chatStatusOfflineAfterDelay;

  // Firebase
  final String fbAppId;

  final String fbApiKey;

  final String fbSenderId;

  final String fbProjectId;

  final String fbAuthDomain;

  final String fbStorageBucket;

  final String fbClientEmail;

  final RSAPrivateKey fbPrivateKey;

  final Duration fbAccessTokenExpiresIn;

  //
  //
  void _printEnvInfo() {
    if (printEnv) {
      print('Debug Mode: [$isDebugModeOn]');
      print('Need Invitation: [$isNeedInvite]');
      print('Invitation TTL: [${invitationTTL.inHours}]');
    }
  }

  static final _env = Platform.environment;

  // JWT

  ///
  /// This key needed for testing purposes only!
  /// You should not use this key on public server!
  /// Be sure if you set your own public key!
  ///
  static const kJwtPublicKey = '''
-----BEGIN PUBLIC KEY-----
MCowBQYDK2VwAyEA2CmIb3Ho2eb6m8WIog6KiyzCY05sbyX04PiGlH5baDw=
-----END PUBLIC KEY-----
''';

  ///
  /// This key needed for testing purposes only!
  /// You should not use this key on public server!
  /// Be sure if you set your own private key!
  ///
  static const kJwtPrivateKey = '''
-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEIN3rCo3wCksyxX4qBYAC1vFr51kx/Od78QVrRLOV1orF
-----END PRIVATE KEY-----
''';

  ///
  /// This key needed for testing purposes only!
  /// You should not use this key on public server!
  /// Be sure if you set your own private key!
  ///
  static const kFbPrivateKey = '''
-----BEGIN PRIVATE KEY-----
MIIBVwIBADANBgkqhkiG9w0BAQEFAASCAUEwggE9AgEAAkEAw1uMRLXleaYdUJ4s
2HXPRMyGuVylBgaQ8k/oNRTuQREtaIOa837PaawFEjuGmWEEDrMQ5M4PBfX+tR5o
u6UUhwIDAQABAkEAnvzqcyD12MLwKKQSKzf1rzAklMZpJzZA0HNnr4uROzGrhoIj
vk/SblgCQI8yq5dqz15lkoF1jr+8bkRrey7cgQIhAOQ/G/zLN2oU5RQePaBfIgVS
7FFou0h5ZtqVgvvgIjRpAiEA2xyq9QzOoVstibx/5lRO8BwSrPjy0/zFdYl3cBW2
I28CIQCA59eRpN/ODLD39MBPU4suQI/wxlqHavEY4DnSsNoAiQIhAMBa9IJYkfX5
k4q9nxLXpM0J+CM+Ef+kgrzix6XwiYulAiEA3S69rX/y7dJdPO1DOOkrDqjB8xF0
uekBTp9n+6fMvCs=
-----END PRIVATE KEY-----
''';
}
