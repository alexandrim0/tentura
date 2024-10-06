sealed class AuthException implements Exception {
  const AuthException();
}

final class AuthExceptionUnknown extends AuthException {
  const AuthExceptionUnknown();
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

class AuthIdNotFoundException extends AuthException {
  const AuthIdNotFoundException();
}
