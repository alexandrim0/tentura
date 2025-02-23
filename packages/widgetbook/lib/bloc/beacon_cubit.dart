import 'package:injectable/injectable.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

@Singleton(as: BeaconCubit)
class BeaconCubitMock extends Cubit<BeaconState> implements BeaconCubit {
  BeaconCubitMock({bool isMine = false})
    : super(
        BeaconState(
          isMine: isMine,
          profileId: profileAlice.id,
          beacons: [beaconA, beaconB],
          hasReachedLast: true,
          offset: 0,
          limit: 0,
        ),
      );

  @override
  Future<void> delete(String beaconId) async {}

  @override
  Future<void> fetch() async {}

  @override
  Future<void> toggleEnabled(String beaconId) async {}
}
