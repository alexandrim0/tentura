import 'package:injectable/injectable.dart';
import 'package:uuid/uuid_value.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/repository/p2p_message_repository.dart';

import '../exception.dart';

@Injectable(order: 2)
class P2pChatCase {
  P2pChatCase(this._env, this._p2pMessageRepository);

  final Env _env;

  final P2pMessageRepository _p2pMessageRepository;

  Future<void> create({
    required String receiverId,
    required String senderId,
    required UuidValue clientId,
    required String content,
  }) => _p2pMessageRepository.create(
    receiverId: receiverId,
    senderId: senderId,
    clientId: clientId,
    content: content,
  );

  Future<void> markAsDelivered({
    required String clientId,
    required String serverId,
    required String receiverId,
  }) async {
    final rowsAffected = await _p2pMessageRepository.markAsDelivered(
      receiverId: receiverId,
      clientId: clientId,
      serverId: serverId,
    );
    if (rowsAffected <= 0) {
      throw const IdNotFoundException();
    }
  }

  Future<void> onUpdatesSubscription({
    required DateTime from,
    required String userId,
    int? batchSize,
  }) async {
    // TBD: create timer worker
    batchSize ??= _env.chatDefaultBatchSize;
  }
}
