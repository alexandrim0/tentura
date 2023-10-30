import 'dart:async';

import 'package:gravity/data/auth_repository.dart';
import 'package:gravity/data/gql/beacon/beacon_utils.dart';
import 'package:gravity/features/beacon/data/_g/beacon_hide_by_id.req.gql.dart';
import 'package:gravity/features/my_field/data/_g/beacon_pin_by_id.req.gql.dart';
import 'package:gravity/features/my_field/data/_g/beacon_fetch_my_field.req.gql.dart';
import 'package:gravity/features/my_field/data/_g/beacon_fetch_my_field.var.gql.dart';
import 'package:gravity/features/my_field/data/_g/beacon_fetch_my_field.data.gql.dart';
import 'package:gravity/ui/utils/ferry_utils.dart';
import 'package:gravity/ui/utils/state_base.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'my_field_state.dart';

typedef _Response
    = OperationResponse<GBeaconFetchMyFieldData, GBeaconFetchMyFieldVars>;

class MyFieldCubit extends Cubit<MyFieldState> {
  static const _requestId = 'FetchMyField';

  MyFieldCubit() : super(const MyFieldState(status: FetchStatus.isLoading)) {
    _subscription = GetIt.I<Client>()
        .request(GBeaconFetchMyFieldReq((b) => b
          ..requestId = _requestId
          ..fetchPolicy = FetchPolicy.NoCache))
        .listen(_onData, cancelOnError: false);
  }

  late final StreamSubscription<_Response> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }

  Future<void> fetch() async {
    GetIt.I<Client>().requestController.add(GBeaconFetchMyFieldReq((b) => b
      ..requestId = _requestId
      ..fetchPolicy = FetchPolicy.NoCache));
  }

  Future<bool?> pinBeacon(String beaconId) async => doRequest(
        request: GBeaconPinByIdReq((b) => b..vars.beacon_id = beaconId),
      ).then(
        (value) {
          if (value.hasNoErrors) {
            state.beacons.removeWhere((e) => e.id == beaconId);
            emit(state.copyWith(status: FetchStatus.hasData));
          }
          return value.hasNoErrors;
        },
      );

  Future<bool?> hideBeacon(String beaconId, Duration? hideFor) async =>
      hideFor == null
          ? null
          : doRequest(
              request: GBeaconHideByIdReq(
                (b) => b
                  ..vars.beacon_id = beaconId
                  ..vars.hidden_until = DateTime.timestamp().add(hideFor),
              ),
            ).then(
              (value) {
                if (value.hasNoErrors) {
                  state.beacons.removeWhere((e) => e.id == beaconId);
                  emit(state.copyWith(status: FetchStatus.hasData));
                }
                return value.hasNoErrors;
              },
            );

  void _onData(_Response response) {
    if (response.loading) {
      emit(state.copyWith(status: FetchStatus.isLoading));
    } else if (response.hasErrors) {
      emit(state.copyWith(status: FetchStatus.hasError));
    } else {
      final beaconIds = <String>{};
      final myField = <GBeaconFields>[];
      final myId = GetIt.I<AuthRepository>().myId;
      final fetched = [
        if (response.data != null)
          ...response.data!.scores
              .map<GBeaconFields>((e) => e.beacon as GBeaconFields),
        ...response.data!.globalScores
            .map<GBeaconFields>((e) => e.beacon as GBeaconFields),
      ];
      for (final beacon in fetched) {
        // TBD: remove that ugly hack when able filter in request
        if (beacon.enabled == false) continue;
        if (beacon.is_hidden ?? false) continue;
        if (beacon.is_pinned ?? false) continue;
        if ((beacon.my_vote ?? 0) < 0) continue;
        if (beacon.author.id == myId) continue;
        if (beaconIds.add(beacon.id)) myField.add(beacon);
      }
      emit(state.copyWith(beacons: myField, status: FetchStatus.hasData));
    }
  }
}