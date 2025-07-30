import 'dart:async';
import 'package:uuid/uuid_value.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/data/repository/fcm_remote_repository.dart';
import 'package:tentura_server/data/repository/fcm_token_repository.dart';
import 'package:tentura_server/data/repository/p2p_message_repository.dart';
import 'package:tentura_server/data/repository/user_presence_repository.dart';
import 'package:tentura_server/data/repository/user_repository.dart';

import '../entity/p2p_message_entity.dart';

@Injectable(order: 2)
class P2pChatCase {
  P2pChatCase(
    this._env,
    this._fcmTokenRepository,
    this._fcmRemoteRepository,
    this._p2pMessageRepository,
    this._userPresenceRepository,
    this._userRepository,
  );

  // ignore: unused_field //
  final Env _env;

  final FcmTokenRepository _fcmTokenRepository;

  final FcmRemoteRepository _fcmRemoteRepository;

  final P2pMessageRepository _p2pMessageRepository;

  final UserPresenceRepository _userPresenceRepository;

  final UserRepository _userRepository;

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
  }) => _p2pMessageRepository.markAsDelivered(
    receiverId: receiverId,
    clientId: clientId,
    serverId: serverId,
  );

  ///
  /// Fetches P2P messages for a specific user from a given point in time.
  ///
  /// This method retrieves messages where the user with the given [userId] is
  /// either the sender or the receiver. It includes messages that were either
  /// created or delivered after the specified [from] timestamp.
  ///
  /// This is useful for syncing a client's message history, as it fetches
  /// both new messages sent/received by the user and updates to the delivery
  /// status of older messages.
  ///
  /// The results are ordered by their creation timestamp in ascending order
  /// and are limited to the [batchSize] specified.
  ///
  /// - [userId]: The ID of the user whose messages are to be fetched.
  ///   Be sure it is sanitized for prevent SQL injection!
  /// - [from]: The timestamp from which to start fetching messages. Only
  ///   messages created or delivered after this time will be returned.
  /// - [batchSize]: The maximum number of messages to return.
  ///
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
        final senderProfile = await _userRepository.getById(senderId);
        await _fcmRemoteRepository.sendFcmMessages(
          fcmTokens: fcmTokens.map((e) => e.token).toSet(),
          title: senderProfile.title,
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
