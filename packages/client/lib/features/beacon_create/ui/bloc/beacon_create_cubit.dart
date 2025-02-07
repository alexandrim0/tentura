import 'package:get_it/get_it.dart';

import 'package:tentura/domain/entity/beacon.dart';
import 'package:tentura/features/image/domain/enum.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/data/repository/beacon_repository.dart';
import 'package:tentura/features/image/data/repository/image_repository.dart';
import 'package:tentura/features/image/domain/entity/image_entity.dart';

import 'beacon_create_state.dart';

class BeaconCreateCubit extends Cubit<BeaconCreateState> {
  BeaconCreateCubit({
    ImageRepository? imageRepository,
    BeaconRepository? beaconRepository,
  })  : _beaconRepository = beaconRepository ?? GetIt.I<BeaconRepository>(),
        _imageRepository = imageRepository ?? GetIt.I<ImageRepository>(),
        super(const BeaconCreateState());

  final BeaconRepository _beaconRepository;

  final ImageRepository _imageRepository;

  Future<void> publish(String context) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final now = DateTime.timestamp();
      final image = state.image ??
          ImageEntity(
            imageBytes: Uint8List(0),
          );
      final result = await _beaconRepository.create(Beacon(
        blurhash: image.blurHash,
        imageHeight: image.height,
        imageWidth: image.width,
        hasPicture: state.image != null,
        coordinates: state.coordinates,
        description: state.description,
        dateRange: state.dateRange,
        title: state.title,
        context: context,
        createdAt: now,
        updatedAt: now,
      ));
      if (image.imageBytes.isNotEmpty) {
        await _imageRepository.putBeaconImage(
          image: image.imageBytes,
          beaconId: result.id,
        );
      }
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }

  Future<void> pickImage() async {
    final image = await _imageRepository.pickImage(
      imageType: ImageType.beacon,
    );
    if (image != null) {
      emit(state.copyWith(
        image: image,
      ));
    }
  }
}
