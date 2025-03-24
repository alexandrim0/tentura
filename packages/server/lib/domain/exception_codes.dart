import 'enum.dart';

sealed class ExceptionCodes {
  const ExceptionCodes();

  int get codeNumber;
}

class AuthExceptionCodes extends ExceptionCodes {
  static const codeSpace = 1000;

  const AuthExceptionCodes(this.exceptionCode);

  final AuthExceptionCode exceptionCode;

  @override
  int get codeNumber => codeSpace + exceptionCode.index;
}
