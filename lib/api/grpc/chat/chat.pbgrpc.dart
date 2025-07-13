// This is a generated file - do not edit.
//
// Generated from chat/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chat_send_message.pb.dart' as $0;
import 'chat_update_message.pb.dart' as $1;
import 'chat_watch_messages.pb.dart' as $2;

export 'chat.pb.dart';

@$pb.GrpcServiceName('tentura.chat.Chat')
class ChatClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChatClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ChatSendMessageResponse> sendMessage($0.ChatSendMessageRequest request, {$grpc.CallOptions? options,}) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$1.ChatUpdateMessageResponse> updateMessage($1.ChatUpdateMessageRequest request, {$grpc.CallOptions? options,}) {
    return $createUnaryCall(_$updateMessage, request, options: options);
  }

  $grpc.ResponseStream<$2.ChatWatchMessagesResponse> watchMessages($2.ChatWatchMessagesRequest request, {$grpc.CallOptions? options,}) {
    return $createStreamingCall(_$watchMessages, $async.Stream.fromIterable([request]), options: options);
  }

    // method descriptors

  static final _$sendMessage = $grpc.ClientMethod<$0.ChatSendMessageRequest, $0.ChatSendMessageResponse>(
      '/tentura.chat.Chat/SendMessage',
      ($0.ChatSendMessageRequest value) => value.writeToBuffer(),
      $0.ChatSendMessageResponse.fromBuffer);
  static final _$updateMessage = $grpc.ClientMethod<$1.ChatUpdateMessageRequest, $1.ChatUpdateMessageResponse>(
      '/tentura.chat.Chat/UpdateMessage',
      ($1.ChatUpdateMessageRequest value) => value.writeToBuffer(),
      $1.ChatUpdateMessageResponse.fromBuffer);
  static final _$watchMessages = $grpc.ClientMethod<$2.ChatWatchMessagesRequest, $2.ChatWatchMessagesResponse>(
      '/tentura.chat.Chat/WatchMessages',
      ($2.ChatWatchMessagesRequest value) => value.writeToBuffer(),
      $2.ChatWatchMessagesResponse.fromBuffer);
}

@$pb.GrpcServiceName('tentura.chat.Chat')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'tentura.chat.Chat';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ChatSendMessageRequest, $0.ChatSendMessageResponse>(
        'SendMessage',
        sendMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChatSendMessageRequest.fromBuffer(value),
        ($0.ChatSendMessageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ChatUpdateMessageRequest, $1.ChatUpdateMessageResponse>(
        'UpdateMessage',
        updateMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ChatUpdateMessageRequest.fromBuffer(value),
        ($1.ChatUpdateMessageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ChatWatchMessagesRequest, $2.ChatWatchMessagesResponse>(
        'WatchMessages',
        watchMessages_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $2.ChatWatchMessagesRequest.fromBuffer(value),
        ($2.ChatWatchMessagesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ChatSendMessageResponse> sendMessage_Pre($grpc.ServiceCall $call, $async.Future<$0.ChatSendMessageRequest> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.ChatSendMessageResponse> sendMessage($grpc.ServiceCall call, $0.ChatSendMessageRequest request);

  $async.Future<$1.ChatUpdateMessageResponse> updateMessage_Pre($grpc.ServiceCall $call, $async.Future<$1.ChatUpdateMessageRequest> $request) async {
    return updateMessage($call, await $request);
  }

  $async.Future<$1.ChatUpdateMessageResponse> updateMessage($grpc.ServiceCall call, $1.ChatUpdateMessageRequest request);

  $async.Stream<$2.ChatWatchMessagesResponse> watchMessages_Pre($grpc.ServiceCall $call, $async.Future<$2.ChatWatchMessagesRequest> $request) async* {
    yield* watchMessages($call, await $request);
  }

  $async.Stream<$2.ChatWatchMessagesResponse> watchMessages($grpc.ServiceCall call, $2.ChatWatchMessagesRequest request);

}
