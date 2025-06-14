import 'package:tentura/domain/entity/polling.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/polling_result.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'polling_state.freezed.dart';

@freezed
abstract class PollingState extends StateBase with _$PollingState {
  const factory PollingState({
    required Polling polling,
    @Default('') String chosenVariant,
    @Default([]) List<PollingResult> results,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _PollingState;

  const PollingState._();

  bool get hasResults => results.isNotEmpty;
  bool get hasNoResults => results.isEmpty;

  bool get canVote =>
      chosenVariant.isNotEmpty && results.isEmpty && status is StateIsSuccess;
}
