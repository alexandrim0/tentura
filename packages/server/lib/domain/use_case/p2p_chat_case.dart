import 'dart:async';
import 'package:uuid/uuid_value.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/repository/fcm_remote_repository.dart';
import 'package:tentura_server/data/repository/fcm_token_repository.dart';
import 'package:tentura_server/data/repository/p2p_message_repository.dart';
import 'package:tentura_server/data/repository/user_presence_repository.dart';

import '../entity/p2p_message_entity.dart';
import '../exception.dart';

@Injectable(order: 2)
class P2pChatCase {
  P2pChatCase(
    this._env,
    this._fcmTokenRepository,
    this._fcmRemoteRepository,
    this._p2pMessageRepository,
    this._userPresenceRepository,
  );

  // ignore: unused_field //
  final Env _env;

  final FcmTokenRepository _fcmTokenRepository;

  final FcmRemoteRepository _fcmRemoteRepository;

  final P2pMessageRepository _p2pMessageRepository;

  final UserPresenceRepository _userPresenceRepository;

  //
  //
  Future<void> create({
    required String receiverId,
    required String senderId,
    required UuidValue clientMessageId,
    required String content,
  }) async {
    await _p2pMessageRepository.create(
      receiverId: receiverId,
      senderId: senderId,
      clientId: clientMessageId,
      content: content,
    );
    unawaited(
      _notifyUser(
        receiverId: receiverId,
        senderId: senderId,
        content: content,
        clientMessageId: clientMessageId,
      ),
    );
  }

  //
  //
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

  //
  //
  Future<Iterable<P2pMessageEntity>> fetchByUserId({
    required DateTime from,
    required String userId,
    required int batchSize,
  }) => _p2pMessageRepository.fetchByUserId(
    id: userId,
    from: from,
    limit: batchSize,
  );

  //
  //
  Future<void> _notifyUser({
    required String receiverId,
    required String senderId,
    required String content,
    required UuidValue clientMessageId,
  }) async {
    final userStatus = await _userPresenceRepository.get(receiverId);

    if (userStatus.shouldNotify) {
      final fcmTokens = await _fcmTokenRepository.getTokensByUserId(
        receiverId,
      );
      if (fcmTokens.isNotEmpty) {
        await _fcmRemoteRepository.sendFcmMessages(
          fcmTokens: fcmTokens.map((e) => e.token),
          title: senderId,
          body: content,
        );
        await _userPresenceRepository.update(
          receiverId,
          lastNotifiedAt: DateTime.timestamp(),
        );
      }
    }
  }
}
