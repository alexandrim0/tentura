sealed class InvitationException implements Exception {}

class InvitationCreateException implements InvitationException {
  const InvitationCreateException();
}

class InvitationDeleteException implements InvitationException {
  const InvitationDeleteException(this.id);

  final String id;
}
