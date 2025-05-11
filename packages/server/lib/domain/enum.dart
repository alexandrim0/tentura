enum Environment { test, dev, prod }

enum HasuraOperation { insert, update, delete, manual }

enum UserRoles { anon, user, admin }

enum AuthExceptionCode {
  unspecifiedException,
  authIdWrongException,
  authIdNotFoundException,
  authPemKeyWrongException,
  authUnauthorizedException,
  authInvitationWrongException,
  authAuthorizationHeaderWrongException,
}
