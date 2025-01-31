import 'dart:typed_data';
import 'package:http/http.dart';

import 'package:tentura_root/consts.dart';

class ImageService {
  const ImageService({
    required this.apiUrlBase,
  });

  final String apiUrlBase;

  Future<void> putAvatar({
    required String token,
    required String userId,
    required Uint8List image,
  }) =>
      put(
        Uri.parse('$apiUrlBase/images/$userId/avatar.jpg'),
        headers: {
          kHeaderContentType: kContentTypeJpeg,
          kHeaderAuthorization: 'Bearer $token',
        },
        body: image,
      );

  Future<void> putBeacon({
    required String token,
    required String userId,
    required String beaconId,
    required Uint8List image,
  }) =>
      put(
        Uri.parse('$apiUrlBase/images/$userId/$beaconId.jpg'),
        headers: {
          kHeaderContentType: kContentTypeJpeg,
          kHeaderAuthorization: 'Bearer $token',
        },
        body: image,
      );
}
