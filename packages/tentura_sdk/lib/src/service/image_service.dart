import 'dart:typed_data';
import 'package:http/http.dart';

class ImageService {
  const ImageService({
    required this.apiUrl,
  });

  final String apiUrl;

  Future<void> putAvatar({
    required String token,
    required String userId,
    required Uint8List image,
  }) =>
      put(
        Uri.parse('$apiUrl/images/$userId/avatar.jpg'),
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
        Uri.parse('$apiUrl/images/$userId/$beaconId.jpg'),
        headers: {
          'Content-Type': 'image/jpeg',
          'Authorization': 'Bearer $token',
        },
        body: image,
      );
}
