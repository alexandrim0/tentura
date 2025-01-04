import 'dart:io' show Platform;

// Make [environment] as mutable for testing purposes only!
final environment = Map<String, String>.from(Platform.environment);

final kSentryDsn = environment['SENTRY_DSN'] ?? '';

final kServerName =
    environment['SERVER_NAME'] ?? 'tentura.intersubjective.space';
// final kServerName = environment['SERVER_NAME'] ?? '';

final kIsHttps = environment['IS_HTTPS'] == 'true';

final kDebugMode = environment['IS_DEBUG_MODE'] == 'true';

// Database connection settings
final kPgHost = environment['POSTGRES_HOST'] ?? 'postgres';
final kPgPort = int.parse(environment['POSTGRES_PORT'] ?? '5432');
final kPgDatabase = environment['POSTGRES_DBNAME'] ?? 'postgres';
final kPgUsername = environment['POSTGRES_USERNAME'] ?? 'postgres';
final kPgPassword = environment['POSTGRES_PASSWORD'] ?? 'password';

// JWT
// This keys needed for testing purposes only!
// You should not use this keys on public server!
// Be sure if you set your own secure keys!
//
final kJwtPublicKey = environment['JWT_PUBLIC_PEM'] ??
    '''
-----BEGIN PUBLIC KEY-----
MCowBQYDK2VwAyEA2CmIb3Ho2eb6m8WIog6KiyzCY05sbyX04PiGlH5baDw=
-----END PUBLIC KEY-----
''';
final kJwtPrivateKey = environment['JWT_PRIVATE_PEM'] ??
    '''
-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEIN3rCo3wCksyxX4qBYAC1vFr51kx/Od78QVrRLOV1orF
-----END PRIVATE KEY-----
''';
final kJwtExpiresIn = Duration(
  seconds: int.parse(environment['JWT_EXPIRES_IN'] ?? '3600'),
);

const kHeaderAuthorization = 'Authorization';
