sealed class ExceptionCodes {
  const ExceptionCodes();

  int get codeNumber;
}

enum GeneralExceptionCode {
  unspecifiedException,
  idWrongException,
  idNotFoundException,
}

class GeneralExceptionCodes extends ExceptionCodes {
  static const codeSpace = 1000;

  const GeneralExceptionCodes(this.exceptionCode);

  final GeneralExceptionCode exceptionCode;

  @override
  int get codeNumber => codeSpace + exceptionCode.index;
}

enum AuthExceptionCode {
  unspecifiedException,
  authPemKeyWrongException,
  authUnauthorizedException,
  authInvitationWrongException,
  authAuthorizationHeaderWrongException,
}

class AuthExceptionCodes extends ExceptionCodes {
  static const codeSpace = 1100;

  const AuthExceptionCodes(this.exceptionCode);

  final AuthExceptionCode exceptionCode;

  @override
  int get codeNumber => codeSpace + exceptionCode.index;
}
