import 'package:grpc/grpc.dart';
import 'package:uuid/uuid.dart';
import 'package:fixnum/fixnum.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_root/api/grpc/chat/chat.pbgrpc.dart';
import 'package:tentura_root/api/grpc/chat/chat_send_message.pb.dart';
import 'package:tentura_root/api/grpc/chat/chat_update_message.pb.dart';
import 'package:tentura_root/api/grpc/chat/chat_watch_messages.pb.dart';

import 'package:tentura_server/env.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/use_case/chat_case.dart';

import 'auth_metadata_x.dart';

@Singleton(order: 3)
class ChatService extends ChatServiceBase {
  ChatService(this._env, this._chatCase);

  final Env _env;

  final ChatCase _chatCase;

  @override
  Future<ChatSendMessageResponse> sendMessage(
    ServiceCall call,
    ChatSendMessageRequest request,
  ) async {
    final message = await _chatCase.create(
      receiverId: request.receiver,
      senderId: call.jwt.sub,
      content: request.content,
    );
    return ChatSendMessageResponse(
      serverId: Uuid.parse(message.id),
      createdAt: Int64(message.createdAt.microsecondsSinceEpoch),
    );
  }

  @override
  Future<ChatUpdateMessageResponse> updateMessage(
    ServiceCall call,
    ChatUpdateMessageRequest request,
  ) async {
    try {
      final message = await _chatCase.markAsDelivered(
        messageId: Uuid.unparse(request.clientId),
        receiverId: call.jwt.sub,
      );
      return ChatUpdateMessageResponse(
        updatedAt: Int64(message.updatedAt.microsecondsSinceEpoch),
      );
    } on UnauthorizedException catch (e) {
      throw GrpcError.permissionDenied(e.description);
    } catch (e) {
      throw GrpcError.unknown(e.toString());
    }
  }

  @override
  Stream<ChatWatchMessagesResponse> watchMessages(
    ServiceCall call,
    ChatWatchMessagesRequest request,
  ) {
    // TBD:
    _env.chatPollingInterval.toString();
    throw const GrpcError.unimplemented();
  }
}
