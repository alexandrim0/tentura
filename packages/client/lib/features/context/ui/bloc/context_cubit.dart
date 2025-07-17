import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/repository_event.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';
import 'package:tentura/features/context/data/repository/context_repository.dart';

import '../../domain/exception.dart';
import '../../domain/entity/context_entity.dart';
import 'context_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'context_state.dart';

/// Global Cubit
@lazySingleton
class ContextCubit extends Cubit<ContextState> {
  ContextCubit({
    bool fromCache = true,
    AuthRepository? authRepository,
    ContextRepository? contextRepository,
  }) : _authRepository = authRepository ?? GetIt.I<AuthRepository>(),
       _contextRepository = contextRepository ?? GetIt.I<ContextRepository>(),
       super(const ContextState()) {
    _contextChanges.resume();
    fetch(fromCache: fromCache);
  }

  @factoryMethod
  ContextCubit.global(this._authRepository, this._contextRepository)
    : super(const ContextState()) {
    _authChanges.resume();
    _contextChanges.resume();
  }

  final AuthRepository _authRepository;

  final ContextRepository _contextRepository;

  late final StreamSubscription<String> _authChanges = _authRepository
      .currentAccountChanges()
      .listen((
        id,
      ) async {
        if (id.isNotEmpty) await fetch(fromCache: false);
      }, cancelOnError: false);

  late final StreamSubscription<RepositoryEvent<ContextEntity>>
  _contextChanges = _contextRepository.changes.listen(
    (event) => switch (event) {
      final RepositoryEventCreate<ContextEntity> entity => emit(
        ContextState(
          contexts: state.contexts..add(entity.value.name),
          selected: state.selected,
        ),
      ),
      final RepositoryEventDelete<ContextEntity> entity => emit(
        ContextState(
          contexts: state.contexts..remove(entity.id),
          selected: state.selected == entity.id ? '' : state.selected,
        ),
      ),
      RepositoryEventUpdate<ContextEntity>() => null,
      RepositoryEventFetch<ContextEntity>() => null,
    },
    cancelOnError: false,
    onError: (Object? e) => emit(
      state.copyWith(
        status: StateHasError(e ?? const ContextUnknownException()),
      ),
    ),
  );

  @disposeMethod
  Future<void> dispose() async {
    await _authChanges.cancel();
    await _contextChanges.cancel();
    return close();
  }

  Future<void> fetch({bool fromCache = true}) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final contexts = await _contextRepository.fetch(fromCache: fromCache);
      emit(ContextState(contexts: contexts.toSet(), selected: state.selected));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  void select(String contextName) =>
      emit(ContextState(contexts: state.contexts, selected: contextName));

  Future<void> add(String? contextName) async {
    if (contextName == null) {
      return;
    } else if (state.contexts.contains(contextName)) {
      select(contextName);
      return;
    }
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _contextRepository.add(contextName);
      emit(
        state.copyWith(selected: contextName, status: StateStatus.isSuccess),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> delete(String contextName) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _contextRepository.delete(
        userId: await _authRepository.getCurrentAccountId(),
        contextName: contextName,
      );
      if (contextName == state.selected) {
        emit(state.copyWith(selected: ''));
      }
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
