import 'package:tentura/ui/bloc/state_base.dart';

part 'graph_state.freezed.dart';

@freezed
class GraphState extends StateBase with _$GraphState {
  const factory GraphState({
    required String focus,
    @Default('') String context,
    @Default(true) bool isAnimated,
    @Default(true) bool positiveOnly,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _GraphState;

  const GraphState._();
}
