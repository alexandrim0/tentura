import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/account.dart';
import '../../domain/exception.dart';
import '../../domain/use_case/auth_case.dart';
import 'auth_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'auth_state.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  @FactoryMethod(preResolve: true)
  static Future<AuthCubit> hydrated(AuthCase authCase) async {
    final state = AuthState(
      accounts: await authCase.getAccountAll(),
      currentAccountId: await authCase.getCurrentAccountId(),
    );
    if (state.isAuthenticated) {
      try {
        await authCase.signIn(
          state.currentAccountId,
          isPpremature: true,
        );
      } catch (e) {
        return AuthCubit(
          authCase: authCase,
          state: state.copyWith(currentAccountId: ''),
        );
      }
    }
    return AuthCubit(authCase: authCase, state: state);
  }

  AuthCubit({
    required AuthCase authCase,
    AuthState state = const AuthState(),
  })  : _authCase = authCase,
        super(state);

  final AuthCase _authCase;

  @disposeMethod
  Future<void> dispose() => close();

  bool checkIfIsMe(String id) => id == state.currentAccountId;

  bool checkIfIsNotMe(String id) => id != state.currentAccountId;

  String getSeedByAccountId(String id) =>
      state.accounts.firstWhereOrNull((e) => e.id == id)?.seed ?? '';

  Future<void> addAccount(String? seed) async {
    if (seed == null) return;
    if (state.accounts.any((e) => e.seed == seed)) {
      return emit(state.setError(const AuthSeedExistsException()));
    }
    emit(state.setLoading());
    try {
      final account = await _authCase.addAccount(seed);
      emit(AuthState(
        currentAccountId: account.id,
        accounts: {
          ...state.accounts,
          Account(id: account.id, seed: seed),
        },
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signUp() async {
    emit(state.setLoading());
    try {
      final account = await _authCase.signUp();
      emit(AuthState(
        currentAccountId: account.id,
        accounts: {
          ...state.accounts,
          account,
        },
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signIn(String id) async {
    emit(state.setLoading());
    try {
      final account = await _authCase.signIn(id);
      emit(AuthState(
        accounts: state.accounts,
        currentAccountId: account.id,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signOut({bool willEmit = true}) async {
    try {
      await _authCase.signOut();
    } catch (e) {
      emit(state.setError(e));
    } finally {
      if (willEmit) emit(AuthState(accounts: state.accounts));
    }
  }

  /// Remove account from local storage
  Future<void> removeAccount(String id) async {
    try {
      await _authCase.removeAccount(id);
    } catch (e) {
      emit(state.setError(e));
    } finally {
      state.accounts.removeWhere((e) => e.id == id);
      emit(AuthState(accounts: {...state.accounts}));
    }
  }
}
