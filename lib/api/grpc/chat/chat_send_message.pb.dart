// This is a generated file - do not edit.
//
// Generated from chat/chat_send_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ChatSendMessageRequest extends $pb.GeneratedMessage {
  factory ChatSendMessageRequest({
    $core.List<$core.int>? clientId,
    $core.String? receiver,
    $core.String? content,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (receiver != null) result.receiver = receiver;
    if (content != null) result.content = content;
    return result;
  }

  ChatSendMessageRequest._();

  factory ChatSendMessageRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ChatSendMessageRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatSendMessageRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'tentura.chat'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'clientId', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'receiver')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSendMessageRequest clone() => ChatSendMessageRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSendMessageRequest copyWith(void Function(ChatSendMessageRequest) updates) => super.copyWith((message) => updates(message as ChatSendMessageRequest)) as ChatSendMessageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatSendMessageRequest create() => ChatSendMessageRequest._();
  @$core.override
  ChatSendMessageRequest createEmptyInstance() => create();
  static $pb.PbList<ChatSendMessageRequest> createRepeated() => $pb.PbList<ChatSendMessageRequest>();
  @$core.pragma('dart2js:noInline')
  static ChatSendMessageRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatSendMessageRequest>(create);
  static ChatSendMessageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get clientId => $_getN(0);
  @$pb.TagNumber(1)
  set clientId($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get receiver => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiver($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceiver() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiver() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);
}

class ChatSendMessageResponse extends $pb.GeneratedMessage {
  factory ChatSendMessageResponse({
    $core.List<$core.int>? serverId,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ChatSendMessageResponse._();

  factory ChatSendMessageResponse.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ChatSendMessageResponse.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatSendMessageResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'tentura.chat'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'serverId', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSendMessageResponse clone() => ChatSendMessageResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSendMessageResponse copyWith(void Function(ChatSendMessageResponse) updates) => super.copyWith((message) => updates(message as ChatSendMessageResponse)) as ChatSendMessageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatSendMessageResponse create() => ChatSendMessageResponse._();
  @$core.override
  ChatSendMessageResponse createEmptyInstance() => create();
  static $pb.PbList<ChatSendMessageResponse> createRepeated() => $pb.PbList<ChatSendMessageResponse>();
  @$core.pragma('dart2js:noInline')
  static ChatSendMessageResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatSendMessageResponse>(create);
  static ChatSendMessageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get serverId => $_getN(0);
  @$pb.TagNumber(1)
  set serverId($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createdAt => $_getI64(1);
  @$pb.TagNumber(2)
  set createdAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => $_clearField(2);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
