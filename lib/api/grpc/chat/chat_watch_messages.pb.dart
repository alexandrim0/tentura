// This is a generated file - do not edit.
//
// Generated from chat/chat_watch_messages.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chat_message.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ChatWatchMessagesRequest extends $pb.GeneratedMessage {
  factory ChatWatchMessagesRequest({
    $fixnum.Int64? from,
  }) {
    final result = create();
    if (from != null) result.from = from;
    return result;
  }

  ChatWatchMessagesRequest._();

  factory ChatWatchMessagesRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ChatWatchMessagesRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatWatchMessagesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'tentura.chat'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'from')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatWatchMessagesRequest clone() => ChatWatchMessagesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatWatchMessagesRequest copyWith(void Function(ChatWatchMessagesRequest) updates) => super.copyWith((message) => updates(message as ChatWatchMessagesRequest)) as ChatWatchMessagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatWatchMessagesRequest create() => ChatWatchMessagesRequest._();
  @$core.override
  ChatWatchMessagesRequest createEmptyInstance() => create();
  static $pb.PbList<ChatWatchMessagesRequest> createRepeated() => $pb.PbList<ChatWatchMessagesRequest>();
  @$core.pragma('dart2js:noInline')
  static ChatWatchMessagesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatWatchMessagesRequest>(create);
  static ChatWatchMessagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get from => $_getI64(0);
  @$pb.TagNumber(1)
  set from($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
}

class ChatWatchMessagesResponse extends $pb.GeneratedMessage {
  factory ChatWatchMessagesResponse({
    $core.Iterable<$0.ChatMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  ChatWatchMessagesResponse._();

  factory ChatWatchMessagesResponse.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ChatWatchMessagesResponse.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatWatchMessagesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'tentura.chat'), createEmptyInstance: create)
    ..pc<$0.ChatMessage>(1, _omitFieldNames ? '' : 'messages', $pb.PbFieldType.PM, subBuilder: $0.ChatMessage.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatWatchMessagesResponse clone() => ChatWatchMessagesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatWatchMessagesResponse copyWith(void Function(ChatWatchMessagesResponse) updates) => super.copyWith((message) => updates(message as ChatWatchMessagesResponse)) as ChatWatchMessagesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatWatchMessagesResponse create() => ChatWatchMessagesResponse._();
  @$core.override
  ChatWatchMessagesResponse createEmptyInstance() => create();
  static $pb.PbList<ChatWatchMessagesResponse> createRepeated() => $pb.PbList<ChatWatchMessagesResponse>();
  @$core.pragma('dart2js:noInline')
  static ChatWatchMessagesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatWatchMessagesResponse>(create);
  static ChatWatchMessagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.ChatMessage> get messages => $_getList(0);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
