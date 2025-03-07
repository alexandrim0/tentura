import 'package:injectable/injectable.dart';

import 'package:tentura_server/domain/use_case/beacon_mutation_case.dart';

import '../models/action_model.dart';
import '_base_controller.dart';

@Injectable(order: 3)
final class ActionsController extends BaseController {
  const ActionsController(this._beaconMutationCase);

  final BeaconMutationCase _beaconMutationCase;

  @override
  Future<Response> handler(Request request) async {
    try {
      final action = ActionModel.fromJson(
        await request.body.asJson as Map<String, dynamic>,
      );

      return switch (action.name) {
        // Beacon
        'delete_beacon_by_id' => Response.ok(
          _beaconMutationCase.handleActionDelete(action.asEntity),
        ),

        // Errors
        final Object? name => Response.badRequest(
          body: {_errorMessageKey: 'Action handler [$name] not found!'},
        ),
      };
    } catch (e) {
      return Response.badRequest(body: {_errorMessageKey: e.toString()});
    }
  }

  static const _errorMessageKey = 'message';
}
