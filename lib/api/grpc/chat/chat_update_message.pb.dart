// This is a generated file - do not edit.
//
// Generated from chat/chat_update_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chat_message_status.pbenum.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ChatUpdateMessageRequest extends $pb.GeneratedMessage {
  factory ChatUpdateMessageRequest({
    $core.List<$core.int>? clientId,
    $0.ChatMessageStatus? status,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (status != null) result.status = status;
    return result;
  }

  ChatUpdateMessageRequest._();

  factory ChatUpdateMessageRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ChatUpdateMessageRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatUpdateMessageRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'tentura.chat'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'clientId', $pb.PbFieldType.OY)
    ..e<$0.ChatMessageStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: $0.ChatMessageStatus.INIT, valueOf: $0.ChatMessageStatus.valueOf, enumValues: $0.ChatMessageStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatUpdateMessageRequest clone() => ChatUpdateMessageRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatUpdateMessageRequest copyWith(void Function(ChatUpdateMessageRequest) updates) => super.copyWith((message) => updates(message as ChatUpdateMessageRequest)) as ChatUpdateMessageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatUpdateMessageRequest create() => ChatUpdateMessageRequest._();
  @$core.override
  ChatUpdateMessageRequest createEmptyInstance() => create();
  static $pb.PbList<ChatUpdateMessageRequest> createRepeated() => $pb.PbList<ChatUpdateMessageRequest>();
  @$core.pragma('dart2js:noInline')
  static ChatUpdateMessageRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatUpdateMessageRequest>(create);
  static ChatUpdateMessageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get clientId => $_getN(0);
  @$pb.TagNumber(1)
  set clientId($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.ChatMessageStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status($0.ChatMessageStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class ChatUpdateMessageResponse extends $pb.GeneratedMessage {
  factory ChatUpdateMessageResponse({
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ChatUpdateMessageResponse._();

  factory ChatUpdateMessageResponse.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ChatUpdateMessageResponse.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatUpdateMessageResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'tentura.chat'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatUpdateMessageResponse clone() => ChatUpdateMessageResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatUpdateMessageResponse copyWith(void Function(ChatUpdateMessageResponse) updates) => super.copyWith((message) => updates(message as ChatUpdateMessageResponse)) as ChatUpdateMessageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatUpdateMessageResponse create() => ChatUpdateMessageResponse._();
  @$core.override
  ChatUpdateMessageResponse createEmptyInstance() => create();
  static $pb.PbList<ChatUpdateMessageResponse> createRepeated() => $pb.PbList<ChatUpdateMessageResponse>();
  @$core.pragma('dart2js:noInline')
  static ChatUpdateMessageResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatUpdateMessageResponse>(create);
  static ChatUpdateMessageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get updatedAt => $_getI64(0);
  @$pb.TagNumber(1)
  set updatedAt($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdatedAt() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdatedAt() => $_clearField(1);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
