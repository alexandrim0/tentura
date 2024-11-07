import 'package:tentura/ui/bloc/state_base.dart';

part 'context_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ContextState with _$ContextState, StateFetchMixin {
  const factory ContextState({
    @Default('') String selected,
    @Default({}) Set<String> contexts,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _ContextState;

  const ContextState._();

  ContextState setLoading() => copyWith(
        status: FetchStatus.isLoading,
        error: null,
      );

  ContextState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
