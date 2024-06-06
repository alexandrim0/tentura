import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/geo.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/use_case/pick_image_case.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../data/beacon_repository.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'beacon_state.dart';

class BeaconCubit extends Cubit<BeaconState> {
  BeaconCubit({
    required BeaconRepository repository,
    PickImageCase pickImageCase = const PickImageCase(),
  })  : _pickImageCase = pickImageCase,
        _repository = repository,
        super(const BeaconState(status: FetchStatus.isLoading)) {
    _repository.authenticationStatus
        .firstWhere((e) => e)
        .then((e) => _fetchSubscription.resume());
  }

  final PickImageCase _pickImageCase;
  final BeaconRepository _repository;

  late final _fetchSubscription = _repository.stream.listen(
    (e) => emit(BeaconState(beacons: e.toList())),
    onError: (dynamic e) => emit(state.setError(e.toString())),
    cancelOnError: false,
  );

  @override
  Future<void> close() async {
    await _fetchSubscription.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    emit(state.setLoading());
    _repository.refetch();
  }

  Future<void> create({
    required String title,
    String description = '',
    DateTimeRange? dateRange,
    Coordinates? coordinates,
    Uint8List? image,
  }) async {
    final beacon = await _repository.create(
      title: title,
      description: description,
      dateRange: dateRange,
      coordinates: coordinates,
      hasPicture: image != null,
    );
    if (image != null && image.isNotEmpty) {
      await _repository.putBeaconImage(
        beaconId: beacon.id,
        image: image,
      );
    }
    emit(BeaconState(
      beacons: [
        beacon,
        ...state.beacons,
      ],
    ));
  }

  Future<void> delete(String beaconId) async {
    await _repository.delete(beaconId);
    emit(BeaconState(
      beacons: state.beacons.where((e) => e.id != beaconId).toList(),
    ));
  }

  Future<void> toggleEnabled(String beaconId) async {
    final beacon = state.beacons.singleWhere((e) => e.id == beaconId);
    state.beacons[state.beacons.indexOf(beacon)] = await _repository.setEnabled(
      isEnabled: !beacon.enabled,
      id: beaconId,
    );
  }

  Future<({String path, String name})?> pickImage() =>
      _pickImageCase.pickImage();
}
