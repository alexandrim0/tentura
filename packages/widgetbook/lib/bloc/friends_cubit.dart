import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/features/friends/ui/bloc/friends_cubit.dart';

import '_data.dart';

@Singleton(as: FriendsCubit)
class FriendsCubitMock extends Cubit<FriendsState> implements FriendsCubit {
  FriendsCubitMock()
    : super(FriendsState(friends: {profileBob.id: profileBob}));

  @override
  Future<void> fetch([String? contextName]) async {}

  @override
  Future<void> addFriend(Profile user) async {
    state.friends[user.id] = user;
    emit(state.copyWith(friends: state.friends));
  }

  @override
  Future<void> removeFriend(Profile user) async {
    state.friends.remove(user.id);
    emit(state.copyWith(friends: state.friends));
  }
}
