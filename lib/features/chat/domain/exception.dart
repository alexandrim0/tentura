sealed class ChatException implements Exception {
  const ChatException(this.message);

  final Object? message;

  @override
  String toString() => message?.toString() ?? super.toString();
}

final class ChatMessageCreateException extends ChatException {
  const ChatMessageCreateException(super.message);
}

final class ChatMessageUpdateException extends ChatException {
  const ChatMessageUpdateException(super.message);
}
