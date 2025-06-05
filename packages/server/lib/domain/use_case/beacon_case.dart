import 'dart:async';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/data/repository/beacon_repository.dart';
import 'package:tentura_server/data/repository/image_repository.dart';
import 'package:tentura_server/data/repository/tasks_repository.dart';
import 'package:tentura_root/domain/entity/coordinates.dart';

import '../entity/task_entity.dart';

@Singleton(order: 2)
class BeaconCase {
  @FactoryMethod(preResolve: true)
  static Future<BeaconCase> createInstance(
    BeaconRepository beaconRepository,
    ImageRepository imageRepository,
    TasksRepository tasksRepository,
  ) async => BeaconCase(beaconRepository, imageRepository, tasksRepository);

  const BeaconCase(
    this._beaconRepository,
    this._imageRepository,
    this._tasksRepository,
  );

  final BeaconRepository _beaconRepository;

  final ImageRepository _imageRepository;

  final TasksRepository _tasksRepository;

  Future<BeaconEntity> create({
    required String userId,
    required String title,
    String? description,
    String? context,
    DateTime? endAt,
    DateTime? startAt,
    Coordinates? coordinates,
    Stream<Uint8List>? imageBytes,
  }) async {
    final beacon = await _beaconRepository.createBeacon(
      authorId: userId,
      title: title,
      context: (context?.isEmpty ?? true) ? null : context,
      description: description ?? '',
      hasPicture: imageBytes != null,
      latitude: coordinates?.lat,
      longitude: coordinates?.long,
      startAt: startAt,
      endAt: endAt,
    );
    if (imageBytes != null) {
      await _imageRepository.putBeaconImage(
        authorId: userId,
        beaconId: beacon.id,
        bytes: imageBytes,
      );
      await _tasksRepository.schedule(
        TaskBeaconImageHash(
          details: TaskBeaconImageHashDetails(
            userId: userId,
            beaconId: beacon.id,
          ),
        ),
      );
    }
    return beacon;
  }

  Future<bool> deleteById({
    required String beaconId,
    required String userId,
  }) async {
    final beacon = await _beaconRepository.getBeaconById(
      beaconId: beaconId,
      filterByUserId: userId,
    );

    await _imageRepository.deleteBeaconImage(
      authorId: beacon.author.id,
      beaconId: beacon.id,
    );
    await _beaconRepository.deleteBeaconById(beacon.id);

    return true;
  }
}
