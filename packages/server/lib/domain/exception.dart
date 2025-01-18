class IdNotFoundException implements Exception {
  const IdNotFoundException([this.message]);

  final String? message;

  @override
  String toString() => 'Id not found: [$message]';
}

class WrongIdException implements Exception {
  const WrongIdException([this.message]);

  final String? message;

  @override
  String toString() => 'Wrong Id: [$message]';
}

class WrongPEMKeyException implements Exception {
  const WrongPEMKeyException([this.message]);

  final String? message;

  @override
  String toString() => 'Wrong PEM keys: [$message]';
}
