sealed class OpinionException implements Exception {
  const OpinionException([this.message]);

  final String? message;
}

final class OpinionFetchException extends OpinionException {
  const OpinionFetchException([super.message]);
}

final class OpinionCreateException extends OpinionException {
  const OpinionCreateException([super.message]);
}

final class OpinionRemoveException extends OpinionException {
  const OpinionRemoveException([super.message]);
}
