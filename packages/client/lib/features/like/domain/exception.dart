sealed class LikeException implements Exception {
  const LikeException([this.message]);

  final Object? message;
}

final class LikeSetException extends LikeException {
  const LikeSetException([super.message]);
}
