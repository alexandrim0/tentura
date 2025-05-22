sealed class AuthRequestIntent {
  const AuthRequestIntent({required this.cname});

  final String cname;

  String get keyCname => 'int';

  static const keyPublicKey = 'pk';

  static const keyRoles = 'roles';
}

final class AuthRequestIntentSignUp extends AuthRequestIntent {
  const AuthRequestIntentSignUp({required this.invitationCode})
    : super(cname: 'sign_up');

  final String invitationCode;

  static const keyCode = 'code';
}

final class AuthRequestIntentSignIn extends AuthRequestIntent {
  const AuthRequestIntentSignIn() : super(cname: 'sign_in');
}

final class AuthRequestIntentSignOut extends AuthRequestIntent {
  const AuthRequestIntentSignOut() : super(cname: 'sign_out');
}
