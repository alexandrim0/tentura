import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/consts.dart';

import '../service/local_storage_service.dart';
import '../service/remote_storage_service.dart';

@Injectable(order: 1)
class ImageRepository {
  static String getBeaconImagePath({
    required String authorId,
    required String beaconId,
  }) => '$kImagesPath/$authorId/$beaconId.$kImageExt';

  static String getUserImagePath({required String userId}) =>
      '$kImageServer/$kImagesPath/$userId/avatar.$kImageExt';

  const ImageRepository(this._localStorageService, this._remoteStorageService);

  final LocalStorageService _localStorageService;

  final RemoteStorageService _remoteStorageService;

  Future<Uint8List> getBeaconImage({
    required String authorId,
    required String beaconId,
  }) {
    final path = getBeaconImagePath(authorId: authorId, beaconId: beaconId);
    return kIsRemoteStorageEnabled
        ? _remoteStorageService.getObject(path)
        : _localStorageService.readFile(path);
  }

  Future<Uint8List> getUserImage({required String userId}) {
    final path = getUserImagePath(userId: userId);
    return kIsRemoteStorageEnabled
        ? _remoteStorageService.getObject(path)
        : _localStorageService.readFile(path);
  }

  Future<String> putBeaconImage({
    required String authorId,
    required String beaconId,
    required Stream<Uint8List> bytes,
  }) {
    final path = getBeaconImagePath(authorId: authorId, beaconId: beaconId);
    return kIsRemoteStorageEnabled
        ? _remoteStorageService.putObject(path, bytes)
        : _localStorageService.saveStreamToFile(path, bytes);
  }

  Future<void> deleteBeaconImage({
    required String authorId,
    required String beaconId,
  }) {
    final path = getBeaconImagePath(authorId: authorId, beaconId: beaconId);
    return kIsRemoteStorageEnabled
        ? _remoteStorageService.removeObject(path)
        : _localStorageService.deleteFile(path);
  }

  Future<String> putUserImage({
    required String userId,
    required Stream<Uint8List> bytes,
  }) {
    final path = getUserImagePath(userId: userId);
    return kIsRemoteStorageEnabled
        ? _remoteStorageService.putObject(path, bytes)
        : _localStorageService.saveStreamToFile(path, bytes);
  }

  Future<void> deleteUserImage({required String userId}) {
    final path = getUserImagePath(userId: userId);
    return kIsRemoteStorageEnabled
        ? _remoteStorageService.removeObject(path)
        : _localStorageService.deleteFile(path);
  }

  Future<void> deleteUserImageAll({required String userId}) {
    final path = '$kImageServer/$kImagesPath/$userId';
    return kIsRemoteStorageEnabled
        ? _remoteStorageService.removeObject(path)
        : _localStorageService.deleteFile(path, recursive: true);
  }
}
