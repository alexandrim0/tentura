import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/repository/message_repository.dart';

@Injectable(order: 2)
class ChatCase {
  ChatCase(this._env, this._messageRepository);

  final Env _env;

  final MessageRepository _messageRepository;

  Future<Object> onMessage(dynamic message) async {
    return _messageRepository.fetchById(_env.environment);
  }
}
