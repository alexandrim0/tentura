import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/bloc/state_base.dart';

part 'auth_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class AuthState extends StateBase with _$AuthState {
  const factory AuthState({
    required DateTime updatedAt,
    @Default('') String currentAccountId,
    @Default([]) List<Profile> accounts,
    @Default(StateIsSuccess()) StateStatus status,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => currentAccountId.isNotEmpty;

  bool get isNotAuthenticated => currentAccountId.isEmpty;

  Profile get currentAccount =>
      currentAccountId.isEmpty
          ? const Profile()
          : accounts.singleWhere((e) => e.id == currentAccountId);
}
