import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura/data/repository/image_repository.dart';
import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/use_case/string_input_validator.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/data/repository/beacon_repository.dart';

import 'beacon_create_state.dart';

export 'package:tentura/ui/bloc/state_base.dart';

export 'beacon_create_state.dart';

class BeaconCreateCubit extends Cubit<BeaconCreateState>
    with StringInputValidator {
  BeaconCreateCubit({
    ImageRepository? imageRepository,
    BeaconRepository? beaconRepository,
  }) : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),
       _imageRepository = imageRepository ?? GetIt.I<ImageRepository>(),
       super(const BeaconCreateState());

  final BeaconRepository _beaconRepository;

  final ImageRepository _imageRepository;

  void setTitle(String value) => emit(state.copyWith(title: value));

  void setDescription(String value) => emit(state.copyWith(description: value));

  void setDateRange(DateTimeRange? value) =>
      emit(state.copyWith(dateRange: value));

  void setLocation(Coordinates? value) =>
      emit(state.copyWith(coordinates: value));

  Future<void> pickImage() async {
    try {
      final image = await _imageRepository.pickImage();
      if (image != null) {
        emit(state.copyWith(image: image));
      }
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  void clearImage() => emit(state.copyWith(image: null));

  Future<void> publish({required String context}) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final now = DateTime.timestamp();
      final result = await _beaconRepository.create(
        Beacon(
          hasPicture: state.image != null,
          coordinates: state.coordinates,
          description: state.description,
          dateRange: state.dateRange,
          title: state.title,
          context: context,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (state.image != null) {
        await _imageRepository.uploadImage(
          image: state.image!,
          imageId: result.id,
        );
      }
      emit(state.copyWith(status: StateIsNavigating.back()));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
