import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/repository_event.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/repository/beacon_repository.dart';

@lazySingleton
class BeaconCase {
  const BeaconCase(
    this._authRepository,
    this._beaconRepository,
  );

  final AuthRepository _authRepository;

  final BeaconRepository _beaconRepository;

  Stream<RepositoryEvent<Beacon>> get beaconChanges =>
      _beaconRepository.changes;

  Stream<String> get currentAccountChanges =>
      _authRepository.currentAccountChanges();

  Future<Beacon> fetchBeaconById(String id) =>
      _beaconRepository.fetchBeaconById(id);

  Future<Iterable<Beacon>> fetchBeaconsByUserId(String id) =>
      _beaconRepository.fetchBeaconsByUserId(id);

  Future<void> create({
    required Beacon beacon,
    Uint8List? image,
  }) async {
    final result = await _beaconRepository.create(beacon.copyWith(
      hasPicture: image != null,
    ));
    if (image != null && image.isNotEmpty) {
      await _beaconRepository.putBeaconImage(
        beaconId: result.id,
        image: image,
      );
    }
  }

  Future<void> delete(String id) => _beaconRepository.delete(id);

  Future<void> setEnabled(
    bool isEnabled, {
    required String id,
  }) =>
      _beaconRepository.setEnabled(
        isEnabled,
        id: id,
      );

  Future<void> putBeaconImage({
    required Uint8List image,
    required String beaconId,
  }) =>
      _beaconRepository.putBeaconImage(
        image: image,
        beaconId: beaconId,
      );
}
