import '../base_controller.dart';

enum Operation { insert, update, delete, manual }

typedef Event =
    ({
      Operation operation,
      Map<String, dynamic>? oldEntity,
      Map<String, dynamic>? newEntity,
    });

base class EventController extends BaseController {
  const EventController();

  Event getEventData(dynamic body) {
    final event = (body as Map)['event'] as Map;
    final data = event['data'] as Map<String, dynamic>;
    final op = (event['op']! as String).toLowerCase();
    return (
      operation: Operation.values.firstWhere((e) => e.name == op),
      oldEntity: data['old'] as Map<String, dynamic>?,
      newEntity: data['new'] as Map<String, dynamic>?,
    );
  }
}
