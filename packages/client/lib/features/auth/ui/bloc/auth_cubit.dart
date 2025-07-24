// TBD: move not void public methods into state
// ignore_for_file: prefer_void_public_cubit_methods
import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/env.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../domain/exception.dart';
import '../../domain/use_case/auth_case.dart';
import 'auth_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'auth_state.dart';

/// Global Cubit
@singleton
class AuthCubit extends Cubit<AuthState> {
  @FactoryMethod(preResolve: true)
  static Future<AuthCubit> hydrated(
    Env env,
    AuthCase authCase,
  ) async {
    final accounts = await authCase.getAccountsAll();
    var state = AuthState(
      accounts: accounts..sort(_compareProfile),
      currentAccountId: await authCase.getCurrentAccountId(),
      updatedAt: DateTime.timestamp(),
    );
    if (state.isAuthenticated) {
      try {
        await authCase.signIn(state.currentAccountId);
      } catch (e) {
        state = state.copyWith(currentAccountId: '');
      }
    }
    return AuthCubit(
      env,
      authCase,
      state,
    );
  }

  AuthCubit(
    this._env,
    this._authCase,
    AuthState state,
  ) : super(state) {
    _authChanges.resume();
    _profileChanges.resume();
  }

  final Env _env;

  final AuthCase _authCase;

  late final StreamSubscription<String> _authChanges = _authCase
      .currentAccountChanges()
      .listen(
        _onAuthChanged,
        cancelOnError: false,
      );

  late final StreamSubscription<RepositoryEvent<Profile>> _profileChanges =
      _authCase.profileChanges.listen(
        _onProfileChanged,
        cancelOnError: false,
      );

  @disposeMethod
  Future<void> dispose() async {
    await _authChanges.cancel();
    await _profileChanges.cancel();
    return close();
  }

  //
  //
  bool checkIfIsMe(String id) => id == state.currentAccountId;

  //
  //
  bool checkIfIsNotMe(String id) => id != state.currentAccountId;

  //
  //
  Future<String> getSeedByAccountId(String id) =>
      _authCase.getSeedByAccountId(id);

  //
  //
  Future<void> addAccount(String? seed) async {
    if (seed == null || seed.isEmpty) {
      return;
    }
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final account = await _authCase.addAccount(seed);
      await _authCase.updateAccount(account);
      emit(
        AuthState(
          accounts: state.accounts
            ..add(account)
            ..sort(_compareProfile),
          updatedAt: DateTime.timestamp(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  //
  Future<void> signUp({
    required String title,
    required String invitationCode,
  }) async {
    if (_env.needInviteCode && invitationCode.isEmpty) {
      emit(
        state.copyWith(
          status: StateHasError(const InvitationCodeIsWrongException()),
        ),
      );
      return;
    }

    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final newProfile = Profile(
        id: await _authCase.signUp(
          invitationCode: invitationCode,
          title: title,
        ),
        title: title,
      );
      emit(
        AuthState(
          accounts: state.accounts
            ..add(newProfile)
            ..sort(_compareProfile),
          currentAccountId: newProfile.id,
          updatedAt: DateTime.timestamp(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  //
  Future<void> signIn(String id) async {
    if (state.currentAccountId == id) return;
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _authCase.signIn(id);
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  //
  Future<void> signOut() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _authCase.signOut();
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  ///
  /// Remove account from local storage
  ///
  Future<void> removeAccount(String id) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _authCase.removeAccount(id);
      emit(
        AuthState(
          accounts: state.accounts..removeWhere((e) => e.id == id),
          updatedAt: DateTime.timestamp(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  //
  Future<void> getSeedFromClipboard() async =>
      addAccount(await _authCase.getSeedFromClipboard());

  //
  //
  Future<String> getCodeFromClipboard() => _authCase.getCodeFromClipboard();

  //
  //
  void _onAuthChanged(String id) => emit(
    AuthState(
      accounts: state.accounts,
      currentAccountId: id,
      updatedAt: DateTime.timestamp(),
    ),
  );

  //
  //
  Future<void> _onProfileChanged(RepositoryEvent<Profile> event) async {
    switch (event) {
      case RepositoryEventDelete<Profile>():
        await removeAccount(event.value.id);

      case RepositoryEventFetch<Profile>():
      case RepositoryEventUpdate<Profile>():
        final index = state.accounts.indexWhere((e) => e.id == event.value.id);

        if (index < 0) return;

        final profile = state.accounts[index];

        if (profile.title == event.value.title &&
            profile.hasAvatar == event.value.hasAvatar) {
          return;
        }
        try {
          state.accounts[index] = profile.copyWith(
            title: event.value.title,
            image: event.value.image,
          );
          emit(
            AuthState(
              accounts: state.accounts,
              currentAccountId: state.currentAccountId,
              updatedAt: DateTime.timestamp(),
            ),
          );
          await _authCase.updateAccount(profile);
        } catch (e) {
          emit(state.copyWith(status: StateHasError(e)));
        }

      case RepositoryEventCreate<Profile>():
    }
  }

  //
  //
  static int _compareProfile(Profile p1, Profile p2) => p1.id.compareTo(p2.id);
}
