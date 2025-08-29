import 'package:tentura/features/profile_view/ui/bloc/profile_view_cubit.dart';

import '_data.dart';

class ProfileViewCubitMock extends Cubit<ProfileViewState>
    implements ProfileViewCubit {
  ProfileViewCubitMock() : super(const ProfileViewState(profile: profileAlice));

  @override
  Future<void> fetch() async {}

  @override
  Future<void> addFriend() async {}

  @override
  Future<void> removeFriend() async {}
}
