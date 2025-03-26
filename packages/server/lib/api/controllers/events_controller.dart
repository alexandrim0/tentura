import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/use_case/beacon_case.dart';
import 'package:tentura_server/domain/use_case/user_case.dart';

import '_base_controller.dart';
import '../models/event_model.dart';

@Injectable(order: 3)
final class EventsController extends BaseController {
  const EventsController(super.env, this._beaconMutationCase, this._userCase);

  final BeaconCase _beaconMutationCase;
  final UserCase _userCase;

  @override
  Future<Response> handler(Request request) async {
    try {
      final event = EventModel.fromJson(
        await request.body.asJson as Map<String, dynamic>,
      );

      switch (event.trigger) {
        case 'beacon_mutate':
          await _beaconMutationCase.handleEvent(event.asEntity);

        case 'user_mutate':
          await _userCase.handleEvent(event.asEntity);

        default:
      }
    } catch (e) {
      return Response.badRequest(body: e);
    }

    return Response.ok(null);
  }
}
