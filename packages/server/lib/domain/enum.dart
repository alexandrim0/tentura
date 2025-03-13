enum Environment { test, dev, prod }

enum HasuraOperation { insert, update, delete, manual }

enum UserRoles { anon, user, admin }

enum ExceptionCode {
  authIdNotFoundException,
  authIdWrongException,
  authPemKeyWrongException,
  authAuthorizationHeaderWrongException,
}
