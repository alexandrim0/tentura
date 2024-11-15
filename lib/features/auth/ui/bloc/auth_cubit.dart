import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  @FactoryMethod(preResolve: true)
  static Future<AuthCubit> hydrated(
    AuthRepository authRepository,
    ProfileRepository profileRepository,
  ) async {
    var state = AuthState(
      accounts: (await authRepository.getAccountsAll())..sort(),
      currentAccountId: await authRepository.getCurrentAccountId(),
      updatedAt: DateTime.timestamp(),
    );
    if (state.isAuthenticated) {
      try {
        await authRepository
            .signIn(
              state.currentAccountId,
              isPremature: true,
            )
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        state = state.copyWith(
          currentAccountId: '',
        );
      }
    }
    return AuthCubit(
      authRepository,
      profileRepository,
      state,
    );
  }

  AuthCubit(
    this._authRepository,
    this._profileRepository,
    AuthState state,
  ) : super(state) {
    _authChanges = _authRepository.currentAccountChanges().listen(
          _onAuthChanged,
          cancelOnError: false,
        );
    _profileChanges = _profileRepository.changes.listen(
      _onProfileChanged,
      cancelOnError: false,
    );
  }

  final AuthRepository _authRepository;

  final ProfileRepository _profileRepository;

  late final StreamSubscription<String> _authChanges;

  late final StreamSubscription<RepositoryEvent<Profile>> _profileChanges;

  @disposeMethod
  Future<void> dispose() async {
    await _authChanges.cancel();
    await _profileChanges.cancel();
    return close();
  }

  Future<String> getSeedByAccountId(String id) =>
      _authRepository.getSeedByAccountId(id);

  Future<void> addAccount(String? seed) async {
    if (seed == null) return;
    emit(state.setLoading());
    try {
      final account = await _authRepository.addAccount(seed);
      final profile = await _profileRepository.fetch(account.id);
      await _authRepository.updateAccount(account);
      emit(AuthState(
        accounts: state.accounts
          ..add(account.copyWith(
            title: profile.title,
            hasAvatar: profile.hasAvatar,
          ))
          ..sort(),
        updatedAt: DateTime.timestamp(),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signUp() async {
    emit(state.setLoading());
    try {
      final account = await _authRepository.signUp();
      emit(AuthState(
        accounts: state.accounts
          ..add(account)
          ..sort(),
        updatedAt: DateTime.timestamp(),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signIn(String id) async {
    if (state.currentAccountId == id) return;
    emit(state.setLoading());
    try {
      await _authRepository.signIn(id);
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signOut() async {
    emit(state.setLoading());
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(state.setError(e));
    }
  }

  /// Remove account from local storage
  Future<void> removeAccount(String id) async {
    emit(state.setLoading());
    try {
      await _authRepository.removeAccount(id);
      emit(AuthState(
        accounts: state.accounts..removeWhere((e) => e.id == id),
        updatedAt: DateTime.timestamp(),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  void _onAuthChanged(String id) => emit(AuthState(
        accounts: state.accounts,
        currentAccountId: id,
        updatedAt: DateTime.timestamp(),
      ));

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
            account.hasAvatar == event.value.hasAvatar) return;
        try {
          state.accounts[index] = account.copyWith(
            title: event.value.title,
            hasAvatar: event.value.hasAvatar,
          );
          emit(AuthState(
            accounts: state.accounts,
            currentAccountId: state.currentAccountId,
            updatedAt: DateTime.timestamp(),
          ));
          await _authRepository.updateAccount(account);
        } catch (e) {
          emit(state.setError(e));
        }

      case RepositoryEventCreate<Profile>():
    }
  }
}
