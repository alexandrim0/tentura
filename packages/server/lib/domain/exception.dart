import 'dart:convert';

import 'enum.dart';

base class ExceptionBase implements Exception {
  const ExceptionBase({required this.code, required this.description});

  final ExceptionCode code;
  final String description;

  Map<String, Object> get toMap => {
    'code': code.index + 1000,
    'description': description,
  };

  @override
  String toString() => jsonEncode(toMap);
}

final class IdNotFoundException extends ExceptionBase {
  const IdNotFoundException({String id = '', String? description})
    : super(
        code: ExceptionCode.authIdNotFoundException,
        description: description ?? 'Id not found: [$id]',
      );
}

final class IdWrongException extends ExceptionBase {
  const IdWrongException({String id = '', String? description})
    : super(
        code: ExceptionCode.authIdNotFoundException,
        description: description ?? 'Wrong Id: [$id]',
      );
}

final class PemKeyWrongException extends ExceptionBase {
  const PemKeyWrongException({String key = '', String? description})
    : super(
        code: ExceptionCode.authIdNotFoundException,
        description: description ?? 'Wrong PEM keys: [$key]',
      );

  @override
  String toString() => 'Wrong PEM keys: [$description]';
}

final class AuthorizationHeaderWrongException extends ExceptionBase {
  const AuthorizationHeaderWrongException()
    : super(
        code: ExceptionCode.authAuthorizationHeaderWrongException,
        description: 'Wrong Authorization header',
      );
}
