sealed class ChatException implements Exception {
  const ChatException(this.message);

  final Object? message;
}

final class ChatMessageCreateException extends ChatException {
  const ChatMessageCreateException(super.message);
}
