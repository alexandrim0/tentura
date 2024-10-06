import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/domain/entity/beacon.dart';
import 'package:tentura/features/profile/domain/entity/profile.dart';

part 'profile_view_state.freezed.dart';

@freezed
class ProfileViewState with _$ProfileViewState, StateFetchMixin {
  const factory ProfileViewState({
    @Default([]) List<Beacon> beacons,
    @Default(Profile()) Profile profile,
    @Default(false) bool hasReachedMax,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _ProfileViewState;

  const ProfileViewState._();

  bool get hasNotReachedMax => !hasReachedMax;

  ProfileViewState setLoading() => copyWith(status: FetchStatus.isLoading);

  ProfileViewState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
