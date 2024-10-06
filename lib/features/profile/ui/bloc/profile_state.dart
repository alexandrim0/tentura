import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/entity/profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState, StateFetchMixin {
  const factory ProfileState({
    @Default(Profile()) Profile profile,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _ProfileState;

  const ProfileState._();

  ProfileState setLoading() => copyWith(status: FetchStatus.isLoading);

  ProfileState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
