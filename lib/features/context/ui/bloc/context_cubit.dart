import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tentura/features/auth/domain/exception.dart';

import '../../domain/use_case/context_case.dart';
import 'context_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'context_state.dart';

@singleton
class ContextCubit extends Cubit<ContextState> {
  @factoryMethod
  ContextCubit.current(this._contextCase)
      : super(const ContextState(userId: '')) {
    _authChanges.resume();
  }

  final ContextCase _contextCase;

  late final _authChanges = _contextCase.currentAccountChanges.listen(
    (id) async {
      emit(ContextState(userId: id));
      if (id.isNotEmpty) await fetch();
    },
    cancelOnError: false,
    onError: (Object? e) =>
        emit(state.setError(e ?? const AuthExceptionUnknown())),
  );

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    emit(state.setLoading());
    try {
      emit(state.copyWith(contexts: (await _contextCase.fetch()).toSet()));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  String select(String contextName) {
    emit(state.copyWith(selected: contextName));
    return contextName;
  }

  Future<void> add({
    required String contextName,
    required bool select,
  }) async {
    if (state.contexts.contains(contextName)) return;
    try {
      final context = await _contextCase.add(contextName);
      emit(state.copyWith(
        selected: context,
        contexts: {context, ...state.contexts},
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  /// Returns `true` if current context deleted
  Future<bool> delete(String contextName) async {
    final isCurrent = state.selected == contextName;
    try {
      await _contextCase.delete(
        contextName: contextName,
        userId: state.userId,
      );
      emit(state.copyWith(
        selected: isCurrent ? '' : state.selected,
        contexts: state.contexts.where((e) => e != contextName).toSet(),
      ));
      return isCurrent;
    } catch (e) {
      emit(state.setError(e));
      return false;
    }
  }
}
