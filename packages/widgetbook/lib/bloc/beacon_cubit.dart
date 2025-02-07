import 'package:injectable/injectable.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';

import 'package:tentura_widgetbook/bloc/_data.dart';

@Singleton(as: BeaconCubit)
class BeaconCubitMock extends Cubit<BeaconState> implements BeaconCubit {
  BeaconCubitMock()
      : super(BeaconState(
          beacons: [
            beaconA,
            beaconB,
          ],
          userId: profileAlice.id,
        ));

  @override
  Future<void> delete(String beaconId) async {}

  @override
  Future<void> fetch() async {}

  @override
  void showBeacon(String id) {}

  @override
  void showBeaconCreate() {}

  @override
  void showGraph(String focus) {}

  @override
  Future<void> toggleEnabled(String beaconId) async {}
}
