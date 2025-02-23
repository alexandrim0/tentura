import 'package:tentura/consts.dart';

import 'state_base.dart';

export 'state_base.dart';

class ScreenCubit extends Cubit<ScreenState> {
  ScreenCubit() : super(const ScreenState());

  void back() => emit(state.navigateBack());

  void showChatWith(String id) =>
      emit(state.navigateTo('$kPathProfileChat?id=$id'));

  void showGraph(String focus) =>
      emit(state.navigateTo('$kPathGraph?focus=$focus'));

  void showRating() => emit(state.navigateTo(kPathRating));

  void showBeacons(String id) =>
      emit(state.navigateTo('$kPathBeaconViewAll?id=$id'));

  void showBeaconCreate() => emit(state.navigateTo(kPathBeaconNew));

  void showBeacon(String id) =>
      emit(state.navigateTo('$kPathBeaconView?id=$id'));

  void showProfile(String id) =>
      emit(state.navigateTo('$kPathProfileView?id=$id'));

  void showProfileEditor() => emit(state.navigateTo(kPathProfileEdit));

  void showSettings() => emit(state.navigateTo(kPathSettings));
}

class ScreenState extends StateBase {
  const ScreenState({super.status});

  ScreenState navigateTo(String path) =>
      ScreenState(status: StateIsNavigating(path));

  ScreenState navigateBack() =>
      ScreenState(status: StateIsNavigating(kPathBack));
}
