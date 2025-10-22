sealed class UserInputException implements Exception {
  const UserInputException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class TitleInputException extends UserInputException {
  const TitleInputException(super.message);

  const TitleInputException.tooShort() : super('Title is too short');

  const TitleInputException.tooLong() : super('Title is too long');
}
