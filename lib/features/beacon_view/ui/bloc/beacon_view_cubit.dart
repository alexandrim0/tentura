import 'package:get_it/get_it.dart';

import 'package:tentura/ui/bloc/state_base.dart';

import 'package:tentura/features/beacon/domain/entity/beacon.dart';
import 'package:tentura/features/profile/domain/entity/profile.dart';

import '../../domain/use_case/beacon_view_case.dart';
import 'beacon_view_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'beacon_view_state.dart';

class BeaconViewCubit extends Cubit<BeaconViewState> {
  BeaconViewCubit({
    required String id,
    required Profile myProfile,
    BeaconViewCase? beaconViewCase,
  })  : _beaconViewCase = beaconViewCase ?? GetIt.I<BeaconViewCase>(),
        super(_idToState(id, myProfile)) {
    state.hasFocusedComment
        // Show Beacon with one Comment
        ? _fetchBeaconByCommentId()
        // show Beacon with all Comments
        : _fetchBeaconByIdWithComments();
  }

  final BeaconViewCase _beaconViewCase;

  Future<void> showAll() async {
    emit(state.setLoading());
    try {
      final comments =
          await _beaconViewCase.fetchCommentsByBeaconId(state.beacon.id);
      emit(state.copyWith(
        focusCommentId: '',
        hasReachedMax: true,
        comments: comments.toList(),
        status: FetchStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> addComment(String text) async {
    emit(state.setLoading());
    try {
      final comment = await _beaconViewCase.addComment(
        beaconId: state.beacon.id,
        content: text,
      );
      emit(state.copyWith(
        status: FetchStatus.isSuccess,
        comments: state.comments
          ..add(comment.copyWith(
            author: state.myProfile,
          )),
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> _fetchBeaconByIdWithComments([int limit = 3]) async {
    emit(state.setLoading());
    try {
      final (:beacon, :comments) =
          await _beaconViewCase.fetchBeaconByIdWithComments(
        beaconId: state.beacon.id,
        limit: limit,
      );
      emit(state.copyWith(
        beacon: beacon,
        comments: comments.toList(),
        hasReachedMax: comments.length < limit,
        status: FetchStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> _fetchBeaconByCommentId() async {
    emit(state.setLoading());
    try {
      final (:beacon, :comment) =
          await _beaconViewCase.fetchBeaconByCommentId(state.focusCommentId);
      emit(state.copyWith(
        beacon: beacon,
        comments: [comment],
        status: FetchStatus.isSuccess,
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  static final _zeroDateTime = DateTime.fromMillisecondsSinceEpoch(0);
  static final _emptyBeacon = Beacon(
    createdAt: _zeroDateTime,
    updatedAt: _zeroDateTime,
  );

  static BeaconViewState _idToState(String id, Profile myProfile) =>
      switch (id) {
        _ when id.startsWith('B') => BeaconViewState(
            beacon: _emptyBeacon.copyWith(id: id),
            myProfile: myProfile,
          ),
        _ when id.startsWith('C') => BeaconViewState(
            beacon: _emptyBeacon,
            focusCommentId: id,
            myProfile: myProfile,
          ),
        _ => BeaconViewState(
            beacon: _emptyBeacon,
            error: 'Wrong id: $id',
            status: FetchStatus.isFailure,
          ),
      };
}
