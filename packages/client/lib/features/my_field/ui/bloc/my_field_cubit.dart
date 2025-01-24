import 'dart:async';
import 'package:get_it/get_it.dart';

import '../../data/repository/my_field_repository.dart';
import 'my_field_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'my_field_state.dart';

class MyFieldCubit extends Cubit<MyFieldState> {
  MyFieldCubit({
    String initialContext = '',
    MyFieldRepository? repository,
  })  : _repository = repository ?? GetIt.I<MyFieldRepository>(),
        super(const MyFieldState()) {
    fetch(initialContext);
  }

  final MyFieldRepository _repository;

  Future<void> fetch([String? contextName]) async {
    emit(state.copyWith(
      status: StateStatus.isLoading,
    ));
    try {
      final beacons = await _repository.fetch(
        context: contextName ?? state.context,
      );
      emit(MyFieldState(
        context: contextName ?? state.context,
        beacons: beacons.toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateHasError(e),
      ));
    }
  }
}
