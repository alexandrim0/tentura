import 'dart:io' show Platform;

import 'package:tentura_root/consts.dart' as tentura;

export 'package:tentura_root/consts.dart' hide kImageServer, kServerName;

// Numbers
const kBlurHashX = 9;

const kBlurHashY = 9;

// Strings
const kContextUserId = 'userId';

// Make [environment] as mutable for testing purposes only!
final environment = Map<String, String>.from(Platform.environment);

final kDebugMode = environment['DEBUG_MODE'] == 'true';

final kBindAddress = environment['BIND_ADDRESS'] ?? '0.0.0.0';

final kListenPort = int.tryParse(environment['LISTEN_PORT'] ?? '') ?? 2080;

final kWorkersCount = int.tryParse(environment['WORKERS_COUNT'] ?? '') ??
    Platform.numberOfProcessors;

final kImageFolderPath = environment['IMAGES_PATH'] ?? '/srv/images';

/// First part of FQDN: `https://app.server.name`
final kServerName = environment['SERVER_NAME'] ?? tentura.kServerName;

/// First part of FQDN: `https://image.server.name`
final kImageServer = environment['IMAGE_SERVER'] ?? tentura.kImageServer;

// Database connection settings
final kPgHost = environment['POSTGRES_HOST'] ?? 'postgres';

final kPgPort = int.tryParse(environment['POSTGRES_PORT'] ?? '') ?? 5432;

final kPgDatabase = environment['POSTGRES_DBNAME'] ?? 'postgres';

final kPgUsername = environment['POSTGRES_USERNAME'] ?? 'postgres';

final kPgPassword = environment['POSTGRES_PASSWORD'] ?? 'password';

final kMaxConnectionCount =
    int.tryParse(environment['POSTGRES_MAXCONN'] ?? '') ?? 25;

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
