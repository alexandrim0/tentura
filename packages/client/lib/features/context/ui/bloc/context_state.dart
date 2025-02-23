import 'package:tentura/ui/bloc/state_base.dart';

export 'package:tentura/ui/bloc/state_base.dart';

part 'context_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ContextState extends StateBase with _$ContextState {
  const factory ContextState({
    @Default('') String selected,
    @Default({}) Set<String> contexts,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _ContextState;

  const ContextState._();
}
