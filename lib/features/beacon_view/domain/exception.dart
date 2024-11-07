sealed class BeaconViewException implements Exception {
  const BeaconViewException([this.message]);

  final String? message;

  @override
  String toString() => message ?? super.toString();
}

final class BeaconViewFetchException extends BeaconViewException {
  const BeaconViewFetchException([super.message]);
}
