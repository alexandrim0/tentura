sealed class BeaconException implements Exception {
  const BeaconException([this.message]);

  final String? message;
}

final class BeaconFetchException extends BeaconException {
  const BeaconFetchException([super.message]);
}

final class BeaconCreateException extends BeaconException {
  const BeaconCreateException([super.message]);
}

final class BeaconUpdateException extends BeaconException {
  const BeaconUpdateException([super.message]);
}
