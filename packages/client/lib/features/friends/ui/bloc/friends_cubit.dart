import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tentura/domain/entity/profile.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../domain/use_case/friends_case.dart';
import 'friends_state.dart';

export 'friends_state.dart';

@singleton
class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(
    this._friendsCase,
    AuthRepository _authRepository,
  ) : super(const FriendsState(friends: {})) {
    _authChanges = _authRepository.currentAccountChanges().listen(
          _onAuthChanged,
          cancelOnError: false,
        );
    _friendsChanges = _friendsCase.friendsChanges.listen(
      _onFriendsChanged,
      cancelOnError: false,
    );
  }

  final FriendsCase _friendsCase;

  late final StreamSubscription<String> _authChanges;

  late final StreamSubscription<Profile> _friendsChanges;

  @override
  @disposeMethod
  Future<void> close() async {
    await _authChanges.cancel();
    await _friendsChanges.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    emit(state.setLoading());
    try {
      final friends = await _friendsCase.fetch();
      emit(FriendsState(
        friends: {
          for (final e in friends) e.id: e,
        },
      ));
    } catch (e) {
      emit(state.setError(e));
    }
  }

  Future<void> addFriend(Profile user) => _friendsCase.addFriend(user);

  Future<void> removeFriend(Profile user) => _friendsCase.removeFriend(user);

  void _onAuthChanged(String userId) {
    // ignore: prefer_const_constructors //
    emit(FriendsState(friends: {}));
    if (userId.isNotEmpty) fetch();
  }

  void _onFriendsChanged(Profile profile) {
    emit(state.setLoading());
    if (profile.isFriend) {
      state.friends[profile.id] = profile;
    } else {
      state.friends.remove(profile.id);
    }
    emit(FriendsState(friends: state.friends));
  }
}
