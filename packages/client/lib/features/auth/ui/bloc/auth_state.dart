import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'auth_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class AuthState with _$AuthState, StateFetchMixin {
  const factory AuthState({
    required DateTime updatedAt,
    @Default('') String currentAccountId,
    @Default([]) List<Profile> accounts,
    @Default(FetchStatus.isSuccess) FetchStatus status,
    Object? error,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => currentAccountId.isNotEmpty;

  bool get isNotAuthenticated => currentAccountId.isEmpty;

  Profile get currentAccount => currentAccountId.isEmpty
      ? const Profile()
      : accounts.singleWhere((e) => e.id == currentAccountId);

  AuthState setLoading() => copyWith(status: FetchStatus.isLoading);

  AuthState setError(Object error) => copyWith(
        status: FetchStatus.isFailure,
        error: error,
      );
}
