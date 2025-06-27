import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/data/repository/image_repository.dart';
import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/domain/entity/polling.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/data/repository/beacon_repository.dart';

import 'beacon_create_state.dart';

export 'package:tentura/ui/bloc/state_base.dart';

export 'beacon_create_state.dart';

class BeaconCreateCubit extends Cubit<BeaconCreateState> {
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

  void setDateRange({DateTime? startAt, DateTime? endAt}) =>
      emit(state.copyWith(startAt: startAt, endAt: endAt));

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

  void setQuestion(String value) => emit(state.copyWith(question: value));

  void addVariant() => emit(state.copyWith(variants: [...state.variants, '']));

  void removeVariant(int index) =>
      emit(state.copyWith(variants: [...state.variants]..removeAt(index)));

  void setVariant(int index, String value) => state.variants[index] = value;

  Future<void> publish({required String context}) async {
    state.variants.removeWhere((e) => e.isEmpty);
    if (state.hasPolling) {
      if (state.question.length < kQuestionMinLength) {
        emit(
          state.copyWith(
            // TBD: l10n
            status: StateHasError('Too shohort question.'),
          ),
        );
        return;
      }
      if (state.variants.length < 2) {
        emit(
          state.copyWith(
            // TBD: l10n
            status: StateHasError('Too few variants. Must be at least 2.'),
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final now = DateTime.timestamp();
      await _beaconRepository.create(
        Beacon(
          createdAt: now,
          updatedAt: now,
          context: context,
          title: state.title,
          coordinates: state.coordinates,
          description: state.description,
          startAt: state.startAt,
          endAt: state.endAt,
          image: state.image,
          polling: state.hasPolling
              ? Polling(
                  createdAt: now,
                  updatedAt: now,
                  question: state.question,
                  variants: {
                    for (var i = 0; i < state.variants.length; i++)
                      i.toString(): state.variants[i],
                  },
                )
              : null,
        ),
      );
      emit(state.copyWith(status: StateIsNavigating.back()));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
