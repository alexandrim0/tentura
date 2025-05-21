import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/domain/use_case/clipboard_case.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import '../../data/repository/auth_repository.dart';
import '../../domain/exception.dart';
import 'auth_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'auth_state.dart';

/// Global Cubit
@singleton
class AuthCubit extends Cubit<AuthState> {
  @FactoryMethod(preResolve: true)
  static Future<AuthCubit> hydrated(
    ClipboardCase clipboardCase,
    AuthRepository authRepository,
    ProfileRepository profileRepository,
  ) async {
    final accounts = await authRepository.getAccountsAll();
    var state = AuthState(
      accounts: accounts..sort(_compareProfile),
      currentAccountId: await authRepository.getCurrentAccountId(),
      updatedAt: DateTime.timestamp(),
    );
    if (state.isAuthenticated) {
      try {
        await authRepository.signIn(state.currentAccountId);
      } catch (e) {
        state = state.copyWith(currentAccountId: '');
      }
    }
    return AuthCubit(clipboardCase, authRepository, profileRepository, state);
  }

  AuthCubit(
    this._clipboardCase,
    this._authRepository,
    this._profileRepository,
    AuthState state,
  ) : super(state) {
    _authChanges.resume();
    _profileChanges.resume();
  }

  final ClipboardCase _clipboardCase;

  final AuthRepository _authRepository;

  final ProfileRepository _profileRepository;

  late final _authChanges = _authRepository.currentAccountChanges().listen(
    _onAuthChanged,
    cancelOnError: false,
  );

  late final _profileChanges = _profileRepository.changes.listen(
    _onProfileChanged,
    cancelOnError: false,
  );

  @disposeMethod
  Future<void> dispose() async {
    await _authChanges.cancel();
    await _profileChanges.cancel();
    return close();
  }

  bool checkIfIsMe(String id) => id == state.currentAccountId;

  bool checkIfIsNotMe(String id) => id != state.currentAccountId;

  Future<String> getSeedByAccountId(String id) =>
      _authRepository.getSeedByAccountId(id);

  Future<void> addAccount(String? seed) async {
    if (seed == null || seed.isEmpty) {
      return;
    }
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final accountId = await _authRepository.addAccount(seed);
      final account = await _profileRepository.fetchById(accountId);
      await _authRepository.updateAccount(account);
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

  Future<void> signUp({
    required String title,
    required String invitationCode,
  }) async {
    if (kNeedInviteCode && invitationCode.isEmpty) {
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
        id: await _authRepository.signUp(
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

  Future<void> signIn(String id) async {
    if (state.currentAccountId == id) return;
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _authRepository.signIn(id);
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  /// Remove account from local storage
  Future<void> removeAccount(String id) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _authRepository.removeAccount(id);
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

  Future<void> getSeedFromClipboard() async =>
      addAccount(await _clipboardCase.getSeedFromClipboard());

  Future<String> getCodeFromClipboard() =>
      _clipboardCase.getCodeFromClipboard(prefix: 'I');

  void _onAuthChanged(String id) => emit(
    AuthState(
      accounts: state.accounts,
      currentAccountId: id,
      updatedAt: DateTime.timestamp(),
    ),
  );

  Future<void> _onProfileChanged(RepositoryEvent<Profile> event) async {
    switch (event) {
      case RepositoryEventDelete<Profile>():
        await removeAccount(event.value.id);

      case RepositoryEventFetch<Profile>():
      case RepositoryEventUpdate<Profile>():
        final index = state.accounts.indexWhere((e) => e.id == event.value.id);

        if (index < 0) return;

        final account = state.accounts[index];

        if (account.title == event.value.title &&
            account.hasAvatar == event.value.hasAvatar) {
          return;
        }
        try {
          state.accounts[index] = account.copyWith(
            title: event.value.title,
            hasAvatar: event.value.hasAvatar,
          );
          emit(
            AuthState(
              accounts: state.accounts,
              currentAccountId: state.currentAccountId,
              updatedAt: DateTime.timestamp(),
            ),
          );
          await _authRepository.updateAccount(account);
        } catch (e) {
          emit(state.copyWith(status: StateHasError(e)));
        }

      case RepositoryEventCreate<Profile>():
    }
  }

  static int _compareProfile(Profile p1, Profile p2) => p1.id.compareTo(p2.id);
}
