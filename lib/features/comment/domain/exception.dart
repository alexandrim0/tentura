sealed class CommentException implements Exception {
  const CommentException([this.message]);

  final String? message;
}

final class CommentCreateException extends CommentException {
  const CommentCreateException([super.message]);
}

final class CommentFetchException extends CommentException {
  const CommentFetchException([super.message]);
}
