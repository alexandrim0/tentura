import 'package:get_it/get_it.dart';

import 'package:tentura/domain/entity/polling.dart';
import 'package:tentura/ui/bloc/state_base.dart';

import '../../data/repository/polling_repository.dart';
import 'polling_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'polling_state.dart';

class PollingCubit extends Cubit<PollingState> {
  PollingCubit({
    required Polling polling,
    PollingRepository? pollingRepository,
  }) : _pollingRepository = pollingRepository ?? GetIt.I<PollingRepository>(),
       super(
         PollingState(
           polling: polling,
           chosenVariant: polling.selection.firstOrNull ?? '',
         ),
       );

  final PollingRepository _pollingRepository;

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final (:polling, :results) = await _pollingRepository.fetchResults(
        pollingId: state.polling.id,
      );
      emit(
        state.copyWith(
          polling: polling,
          results: results,
          chosenVariant: polling.selection.firstOrNull ?? '',
          status: StateStatus.isSuccess,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  void chooseVariant(String variantId) {
    emit(state.copyWith(chosenVariant: variantId));
  }

  Future<void> vote() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _pollingRepository.vote(
        pollingId: state.polling.id,
        variantId: state.chosenVariant,
      );
      await fetch();
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
