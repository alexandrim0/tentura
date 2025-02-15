import 'package:tentura_root/consts.dart';

mixin RemoteStorageHelper {
  String getUserObjectName({required String userId}) =>
      '$kImagesPath/$userId/avatar.$kImageExt';

  String getBeaconObjectName({
    required String userId,
    required String beaconId,
  }) => '$kImagesPath/$userId/$beaconId.$kImageExt';
}
