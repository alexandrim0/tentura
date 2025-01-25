import 'package:injectable/injectable.dart';

import 'package:tentura/features/context/ui/bloc/context_cubit.dart';

@Singleton(as: ContextCubit)
class ContextCubitMock extends Cubit<ContextState> implements ContextCubit {
  ContextCubitMock()
      : super(const ContextState(
          contexts: {
            'InContext',
            'OutContext',
            'NoneContext',
          },
        ));

  @override
  Future<void> add(
    String? contextName, {
    bool select = true,
  }) async {
    if (contextName == null || state.contexts.contains(contextName)) {
      return;
    }
    if (select) {
      emit(state.copyWith(
        selected: contextName,
      ));
    }
  }

  @override
  Future<void> delete(String contextName) async {
    if (contextName.isEmpty) {
      return;
    }
    state.contexts.remove(contextName);
    if (contextName == state.selected) {
      emit(state.copyWith(
        selected: '',
      ));
    } else {
      emit(state.copyWith());
    }
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<void> fetch({bool fromCache = true}) async {}

  @override
  String select(String contextName) {
    emit(ContextState(
      contexts: state.contexts,
      selected: contextName,
    ));
    return contextName;
  }
}
