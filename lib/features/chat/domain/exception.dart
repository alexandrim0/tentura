sealed class ChatException implements Exception {
  const ChatException(this.message);

  final Object? message;
}

final class ChatMessageCreateException extends ChatException {
  const ChatMessageCreateException(super.message);
}

final class ChatMessageUpdateException extends ChatException {
  const ChatMessageUpdateException(super.message);
}
