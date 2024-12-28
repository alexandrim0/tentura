const kDebugMode = bool.fromEnvironment(
  'IS_DEBUG_MODE',
);

const kPublicKey = String.fromEnvironment(
  'JWT_PUBLIC_PEM',
);

const kPrivateKey = String.fromEnvironment(
  'JWT_PRIVATE_PEM',
);

const kSentryDsn = String.fromEnvironment(
  'SENTRY_DSN',
);
