sealed class AuthException implements Exception {
  const AuthException();
}

final class AuthUnknownException extends AuthException {
  const AuthUnknownException();

  @override
  String toString() => 'Unknown error!';
}

class AuthSeedExistsException extends AuthException {
  const AuthSeedExistsException();

  @override
  String toString() => 'Seed already exists';
}

class AuthSeedIsWrongException extends AuthException {
  const AuthSeedIsWrongException();

  @override
  String toString() => 'There is no correct seed!';
}

class AuthIdIsWrongException extends AuthException {
  const AuthIdIsWrongException();

  @override
  String toString() => 'Account ID is wrong!';
}
