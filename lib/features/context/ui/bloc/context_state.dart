import 'package:tentura/ui/bloc/state_base.dart';

part 'context_state.freezed.dart';

@freezed
class ContextState with _$ContextState, StateFetchMixin {
  const factory ContextState({
    required String userId,
    @Default('') String selected,
    @Default({}) Set<String> contexts,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _ContextState;

  const ContextState._();

  ContextState setLoading() => copyWith(status: FetchStatus.isLoading);

  ContextState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
