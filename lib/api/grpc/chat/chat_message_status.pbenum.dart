// This is a generated file - do not edit.
//
// Generated from chat/chat_message_status.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ChatMessageStatus extends $pb.ProtobufEnum {
  static const ChatMessageStatus INIT = ChatMessageStatus._(0, _omitEnumNames ? '' : 'INIT');
  static const ChatMessageStatus SENDING = ChatMessageStatus._(1, _omitEnumNames ? '' : 'SENDING');
  static const ChatMessageStatus SENT = ChatMessageStatus._(2, _omitEnumNames ? '' : 'SENT');
  static const ChatMessageStatus SEEN = ChatMessageStatus._(3, _omitEnumNames ? '' : 'SEEN');
  static const ChatMessageStatus ERROR = ChatMessageStatus._(4, _omitEnumNames ? '' : 'ERROR');
  static const ChatMessageStatus CLEAR = ChatMessageStatus._(5, _omitEnumNames ? '' : 'CLEAR');

  static const $core.List<ChatMessageStatus> values = <ChatMessageStatus> [
    INIT,
    SENDING,
    SENT,
    SEEN,
    ERROR,
    CLEAR,
  ];

  static final $core.List<ChatMessageStatus?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ChatMessageStatus? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatMessageStatus._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
