import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/ui/bloc/state_base.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

//
// If code obfuscation is needed then visit
//   https://github.com/felangel/bloc/issues/3255
//
class AuthCubit extends Cubit<AuthState> with HydratedMixin<AuthState> {
  AuthCubit(RemoteApiService remoteApiService)
      : _remoteApiService = remoteApiService,
        super(const AuthState()) {
    hydrate();
    if (state.isAuthenticated) {
      try {
        _remoteApiService.signIn(
          seed: state.accounts[state.currentAccount]!,
          prematureUserId: state.currentAccount,
        );
      } catch (e) {
        emit(state.setError(e));
      }
    }
  }

  final RemoteApiService _remoteApiService;

  @override
  AuthState? fromJson(Map<String, dynamic> json) => json.isEmpty
      ? null
      : AuthState(
          currentAccount: json['currentAccount'] as String? ?? '',
          accounts: {
            for (final e in (json['accounts'] as Map? ?? {}).entries)
              e.key.toString(): e.value.toString(),
          },
        );

  @override
  Map<String, dynamic>? toJson(AuthState state) =>
      state.currentAccount == this.state.currentAccount &&
              state.accounts == this.state.accounts
          ? null
          : {
              'currentAccount': state.currentAccount,
              'accounts': state.accounts,
            };

  bool checkIfIsMe(String id) => id == state.currentAccount;

  bool checkIfIsNotMe(String id) => id != state.currentAccount;

  Future<void> recoverAccount(String? seed) async {
    if (seed == null) return;
    if (state.accounts.values.contains(seed)) {
      return emit(state.setError(const SeedExistsException()));
    }
    emit(state.setLoading());
    try {
      final id = await _remoteApiService.signIn(seed: seed);
      emit(AuthState(
        currentAccount: id,
        accounts: {
          ...state.accounts,
          id: seed,
        },
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signUp() async {
    emit(state.setLoading());
    try {
      final (:id, :seed) = await _remoteApiService.signUp();
      emit(AuthState(
        currentAccount: id,
        accounts: {
          ...state.accounts,
          id: seed,
        },
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signIn(String id) async {
    emit(state.setLoading());
    try {
      await _remoteApiService.signIn(seed: state.accounts[id]!);
      emit(AuthState(
        currentAccount: id,
        accounts: state.accounts,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signOut({bool willEmit = true}) async {
    try {
      await _remoteApiService.signOut();
    } finally {
      if (willEmit) emit(AuthState(accounts: state.accounts));
    }
  }

  /// Remove account from local storage
  void removeAccount(String id) {
    state.accounts.remove(id);
    emit(AuthState(
      accounts: {...state.accounts},
      currentAccount: state.currentAccount,
    ));
  }
}

class SeedExistsException implements Exception {
  const SeedExistsException();
}

class SeedIsWrongException implements Exception {
  const SeedIsWrongException();
}
