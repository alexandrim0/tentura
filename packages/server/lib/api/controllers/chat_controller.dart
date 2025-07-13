import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/domain/use_case/chat_case.dart';

import '_base_controller.dart';

@Singleton(order: 3)
final class ChatController {
  ChatController(this._env, this._chatCase);

  final Env _env;

  final ChatCase _chatCase;

  final _sessions = <WebSocketSession, ({Timer timer, DateTime lastSeen})>{};

  WebSocketSession handler() => WebSocketSession(
    onOpen: (session) {
      _sessions[session] = (
        timer: Timer.periodic(
          _env.chatPollingInterval,
          // TBD: poll updates from DB
          (timer) {},
        ),
        lastSeen: DateTime.now(),
      );
    },
    onClose: (session) {
      _sessions.remove(session)?.timer.cancel();
    },
    onError: (session, error) {
      final err = 'Error occurred [$error]';
      print(err);
      session.sender.close(100, err);
    },
    onMessage: (session, data) async {
      print(data);
      await _chatCase.onMessage(data);
    },
  );
}
