import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';
import 'package:tentura/features/profile_view/ui/bloc/profile_view_state.dart';

import '_data.dart';

class ProfileViewCubit extends Cubit<ProfileViewState> {
  ProfileViewCubit() : super(const ProfileViewState(profile: profileAlice));

  Future<void> addFriend() async {}

  Future<void> fetchBeacons() async {}

  Future<void> fetchMore() async {}

  Future<void> fetchProfile([int limit = 3]) async {}

  Future<void> removeFriend() async {}

  Future<void> showGraph(String focus) async {}

  Future<void> showBeacons(String id) async {}
}
