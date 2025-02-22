import 'package:injectable/injectable.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

@Singleton(as: BeaconCubit)
class BeaconCubitMock extends Cubit<BeaconState> implements BeaconCubit {
  BeaconCubitMock({bool isMine = false})
    : super(
        BeaconState(
          beacons: [beaconA, beaconB],
          isMine: isMine,
          profileId: profileAlice.id,
        ),
      );

  @override
  Future<void> delete(String beaconId) async {}

  @override
  Future<void> fetch() async {}

  @override
  Future<void> toggleEnabled(String beaconId) async {}
}
