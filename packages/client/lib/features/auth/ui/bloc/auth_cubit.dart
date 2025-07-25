// TBD: move not void public methods into state
// ignore_for_file: prefer_void_public_cubit_methods
import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/env.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import '../../domain/exception.dart';
import '../../domain/use_case/account_case.dart';
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
    AccountCase accountCase,
    ProfileRepository profileRepository,
  ) async {
    final accounts = await accountCase.getAccountsAll();
    var state = AuthState(
      accounts: accounts..sort(_compareProfile),
      currentAccountId: await authCase.getCurrentAccountId(),
      updatedAt: DateTime.timestamp(),
    );
    if (state.isAuthenticated) {
      try {
        await authCase.signIn(
          userId: state.currentAccountId,
        );
      } catch (e) {
        state = state.copyWith(currentAccountId: '');
      }
    }
    return AuthCubit(
      env,
      authCase,
      accountCase,
      profileRepository,
      state,
    );
  }

  AuthCubit(
    this._env,
    this._authCase,
    this._accountCase,
    ProfileRepository profileRepository,
    AuthState state,
  ) : super(state) {
    _authChanges = _authCase.currentAccountChanges().listen(
      _onAuthChanged,
      cancelOnError: false,
    );
    _profileChanges = profileRepository.changes.listen(
      _onProfileChanged,
      cancelOnError: false,
    );
  }

  final Env _env;

  final AuthCase _authCase;

  final AccountCase _accountCase;

  late final StreamSubscription<String> _authChanges;

  late final StreamSubscription<RepositoryEvent<Profile>> _profileChanges;

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
  Future<String> getSeedByAccountId(String accountId) =>
      _accountCase.getSeedByAccountId(accountId);

  //
  //
  Future<void> addAccount(String? seed) async {
    if (seed == null || seed.isEmpty) {
      return;
    }
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final account = await _accountCase.addAccount(seed);
      await _accountCase.updateAccount(account);
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
      await _authCase.signIn(userId: id);
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
      await _accountCase.removeAccount(id);
      await _authCase.signOut();
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
      addAccount(await _accountCase.getSeedFromClipboard());

  //
  //
  Future<String> getCodeFromClipboard() => _accountCase.getCodeFromClipboard();

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
          await _accountCase.updateAccount(profile);
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
