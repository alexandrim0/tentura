class GraphQLException implements Exception {
  const GraphQLException({
    this.label = 'No label',
    this.error = 'Unknown error on OperationRequest',
  });

  final Object? error;
  final String? label;

  @override
  String toString() => '$label: $error';
}

class GraphQLNoDataException implements Exception {
  const GraphQLNoDataException({
    this.label = 'No label',
  });

  final String? label;

  @override
  String toString() => '$label: OperationResponse has no data';
}

sealed class AuthenticationException implements Exception {
  const AuthenticationException([this.description]);

  final String? description;

  @override
  String toString() => description ?? super.toString();
}

final class AuthenticationNoKeyException extends AuthenticationException {
  const AuthenticationNoKeyException([
    super.description = 'Key pair is not set.',
  ]);
}

final class AuthenticationHttpException extends AuthenticationException {
  const AuthenticationHttpException([
    super.description = 'General HTTP error.',
  ]);
}

final class AuthenticationFailedException extends AuthenticationException {
  const AuthenticationFailedException([
    super.description = 'Authorization failed. Wrong token',
  ]);
}

final class AuthenticationNotFoundException extends AuthenticationException {
  const AuthenticationNotFoundException([
    super.description = 'Authorization failed. User not found',
  ]);
}

final class AuthenticationDuplicatedException extends AuthenticationException {
  const AuthenticationDuplicatedException([
    super.description = 'Authorization failed. User registered already',
  ]);
}

final class AuthenticationServerException extends AuthenticationException {
  const AuthenticationServerException([
    super.description = 'Internal server error.',
  ]);
}
