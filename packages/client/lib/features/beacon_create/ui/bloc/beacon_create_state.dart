import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'beacon_create_state.freezed.dart';

@freezed
class BeaconCreateState extends StateBase with _$BeaconCreateState {
  const factory BeaconCreateState({
    @Default('') String title,
    @Default('') String description,
    DateTimeRange? dateRange,
    Coordinates? coordinates,
    Uint8List? image,
    String? blurHash,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _BeaconCreateState;

  const BeaconCreateState._();
}
