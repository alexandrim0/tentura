import 'package:get_it/get_it.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';

import '../../data/repository/opinion_repository.dart';
import 'opinion_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'opinion_state.dart';

class OpinionCubit extends Cubit<OpinionState> {
  OpinionCubit({
    required String objectId,
    required Profile myProfile,
    OpinionRepository? opinionRepository,
  }) : _opinionRepository = opinionRepository ?? GetIt.I<OpinionRepository>(),
       super(
         OpinionState(myProfile: myProfile, objectId: objectId, opinions: []),
       ) {
    fetch();
  }

  final OpinionRepository _opinionRepository;

  void showProfile(String id) => emit(
    state.copyWith(status: StateIsNavigating('$kPathProfileView?id=$id')),
  );

  Future<void> fetch() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      emit(
        state.copyWith(
          status: StateStatus.isSuccess,
          opinions: await _opinionRepository.fetchByObjectId(
            objectId: state.objectId,
            offset: 0,
            limit: 10,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> addOpinion(String text) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final opinion = await _opinionRepository.createOpinion(
        objectId: state.objectId,
        content: text,
      );
      state.opinions.add(opinion.copyWith(author: state.myProfile));
      emit(state.copyWith(status: StateStatus.isSuccess));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  Future<void> removeOpinionById(String id) async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      await _opinionRepository.removeOpinionById(id);
      state.opinions.removeWhere((e) => e.id == id);
      emit(state.copyWith(status: StateStatus.isSuccess));
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }
}
