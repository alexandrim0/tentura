import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'beacon_create_state.freezed.dart';

@freezed
abstract class BeaconCreateState extends StateBase with _$BeaconCreateState {
  const factory BeaconCreateState({
    @Default('') String title,
    @Default('') String description,
    @Default('') String question,
    @Default([]) List<String> variants,
    @Default({}) Set<String> tags,
    Coordinates? coordinates,
    DateTime? startAt,
    DateTime? endAt,
    ImageEntity? image,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _BeaconCreateState;

  const BeaconCreateState._();

  bool get hasPolling => question.isNotEmpty && variants.isNotEmpty;
}
