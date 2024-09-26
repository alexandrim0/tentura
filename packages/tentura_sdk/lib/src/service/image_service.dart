import 'dart:typed_data';
import 'package:http/http.dart';

class ImageService {
  const ImageService({
    required this.serverName,
  });

  final String serverName;

  Future<void> putAvatar({
    required String token,
    required String userId,
    required Uint8List image,
  }) =>
      put(
        Uri.https(serverName, '/images/$userId/avatar.jpg'),
        headers: {
          'Content-Type': 'image/jpeg',
          'Authorization': 'Bearer $token',
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
        Uri.https(serverName, '/images/$userId/$beaconId.jpg'),
        headers: {
          'Content-Type': 'image/jpeg',
          'Authorization': 'Bearer $token',
        },
        body: image,
      );
}
