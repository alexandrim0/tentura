import 'dart:typed_data';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';

import '_data.dart';

@Singleton(as: ProfileCubit)
class ProfileCubitMock extends Cubit<ProfileState> implements ProfileCubit {
  ProfileCubitMock()
      : super(const ProfileState(
          profile: profileAlice,
        ));

  @override
  Future<void> delete() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> fetch() async {}

  @override
  Future<void> putAvatarImage(Uint8List image) async {}

  @override
  void showGraph(String focus) {}

  @override
  void showProfile(String id) {}

  @override
  void showProfileEditor() {}

  @override
  void showRating() {}

  @override
  Future<void> update(Profile profile) async {}
}
