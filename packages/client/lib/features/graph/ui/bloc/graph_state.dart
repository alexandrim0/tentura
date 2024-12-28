import 'package:tentura/ui/bloc/state_base.dart';

part 'graph_state.freezed.dart';

@freezed
class GraphState with _$GraphState, StateFetchMixin {
  const factory GraphState({
    required String focus,
    @Default('') String context,
    @Default(true) bool isAnimated,
    @Default(true) bool positiveOnly,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _GraphState;

  const GraphState._();

  GraphState setLoading() => copyWith(status: FetchStatus.isLoading);

  GraphState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
