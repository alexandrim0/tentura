sealed class AuthException implements Exception {
  const AuthException();
}

final class AuthUnknownException extends AuthException {
  const AuthUnknownException();
}

class AuthSeedExistsException extends AuthException {
  const AuthSeedExistsException();
}

class AuthSeedIsWrongException extends AuthException {
  const AuthSeedIsWrongException();
}

class AuthIdIsWrongException extends AuthException {
  const AuthIdIsWrongException();
}
