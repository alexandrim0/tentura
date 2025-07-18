import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/use_case/user_presence_case.dart';

base mixin WebsocketPathUserPresence {
  UserPresenceCase get userPresenceCase;

  Future<void> onUserPresence(
    JwtEntity jwt,
    Map<String, dynamic> payload,
  ) async {
    final intent = payload['intent'];
    return switch (intent) {
      'set_status' => userPresenceCase.update(
        userId: jwt.sub,
        status: UserPresenceStatus.values.firstWhere(
          (e) => e.name == payload['status'] as String?,
        ),
      ),
      _ => throw UnsupportedError('$intent is not supported!'),
    };
  }
}
