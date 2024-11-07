import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          isPremature: true,
        );
      } catch (e) {
        return AuthCubit(
          authCase: authCase,
          state: state.copyWith(
            currentAccountId: '',
          ),
        );
      }
    }
    return AuthCubit(
      authCase: authCase,
      state: state,
    );
  }

  AuthCubit({
    required AuthCase authCase,
    AuthState state = const AuthState(),
  })  : _authCase = authCase,
        super(state) {
    _authChanges.resume();
  }

  final AuthCase _authCase;

  late final _authChanges = _authCase.currentAccountChanges.listen(
    (id) => emit(AuthState(
      accounts: state.accounts,
      currentAccountId: id,
    )),
    cancelOnError: false,
  );

  @disposeMethod
  Future<void> dispose() async {
    await _authChanges.cancel();
    return close();
  }

  String getSeedByAccountId(String id) =>
      state.accounts.firstWhereOrNull((e) => e.id == id)?.seed ?? '';

  Future<void> addAccount(String? seed) async {
    if (seed == null) return;
    if (state.accounts.any((e) => e.seed == seed)) {
      return emit(state.setError(const AuthSeedExistsException()));
    }
    emit(state.setLoading());
    try {
      emit(AuthState(
        accounts: state.accounts..add(await _authCase.addAccount(seed)),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signUp() async {
    emit(state.setLoading());
    try {
      emit(AuthState(
        accounts: state.accounts..add(await _authCase.signUp()),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signIn(String id) async {
    emit(state.setLoading());
    try {
      await _authCase.signIn(id);
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> signOut() async {
    emit(state.setLoading());
    try {
      await _authCase.signOut();
    } catch (e) {
      emit(state.setError(e));
    }
  }

  /// Remove account from local storage
  Future<void> removeAccount(String id) async {
    emit(state.setLoading());
    try {
      await _authCase.removeAccount(id);
      emit(AuthState(
        accounts: state.accounts..removeWhere((e) => e.id == id),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }
}
