const kDebugMode = bool.fromEnvironment('IS_DEBUG_MODE');

const kPgHost = String.fromEnvironment(
  'POSTGRES_USERNAME',
  defaultValue: 'postgres',
);

const kPgDatabase = String.fromEnvironment(
  'POSTGRES_DATABASE',
  defaultValue: 'postgres',
);

const kPgUsername = String.fromEnvironment(
  'POSTGRES_USERNAME',
  defaultValue: 'postgres',
);

const kPgPassword = String.fromEnvironment('POSTGRES_PASSWORD');

const kPublicKey = String.fromEnvironment('JWT_PUBLIC_PEM');

const kPrivateKey = String.fromEnvironment('JWT_PRIVATE_PEM');

const kSentryDsn = String.fromEnvironment('SENTRY_DSN');
