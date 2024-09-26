import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tentura/domain/entity/geo.dart';
import 'package:tentura/domain/use_case/pick_image_case.dart';

import '../../data/beacon_repository.dart';
import '../../domain/entity/beacon.dart';
import 'beacon_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'beacon_state.dart';

class BeaconCubit extends Cubit<BeaconState> with PickImageCase {
  static final _zeroDateTime = DateTime.fromMillisecondsSinceEpoch(0);

  BeaconCubit({
    required this.userId,
    BeaconRepository? beaconRepository,
  })  : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),
        super(const BeaconState()) {
    fetch();
  }

  final String userId;

  final BeaconRepository _beaconRepository;

  Future<void> fetch() async {
    emit(state.setLoading());
    try {
      final beacons = await _beaconRepository.fetchBeaconsByUserId(userId);
      emit(BeaconState(beacons: beacons.toList()));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> create({
    required String title,
    String description = '',
    DateTimeRange? dateRange,
    Coordinates? coordinates,
    Uint8List? image,
    String? context,
  }) async {
    try {
      final beacon = await _beaconRepository.create(Beacon(
        title: title,
        dateRange: dateRange,
        coordinates: coordinates,
        description: description,
        createdAt: _zeroDateTime,
        updatedAt: _zeroDateTime,
        hasPicture: image != null,
        context: context ?? '',
      ));
      if (image != null && image.isNotEmpty) {
        await _beaconRepository.putBeaconImage(
            beaconId: beacon.id, image: image);
      }
      emit(BeaconState(beacons: [beacon, ...state.beacons]));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> delete(String beaconId) async {
    try {
      await _beaconRepository.delete(beaconId);
      emit(BeaconState(
        beacons: state.beacons.where((e) => e.id != beaconId).toList(),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> toggleEnabled(String beaconId) async {
    try {
      final beacon = state.beacons.singleWhere((e) => e.id == beaconId);
      state.beacons[state.beacons.indexOf(beacon)] =
          await _beaconRepository.setEnabled(
        isEnabled: !beacon.isEnabled,
        id: beaconId,
      );
      emit(BeaconState(beacons: state.beacons));
    } catch (e) {
      emit(state.setError(e));
    }
  }
}
