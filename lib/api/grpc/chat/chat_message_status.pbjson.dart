// This is a generated file - do not edit.
//
// Generated from chat/chat_message_status.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chatMessageStatusDescriptor instead')
const ChatMessageStatus$json = {
  '1': 'ChatMessageStatus',
  '2': [
    {'1': 'INIT', '2': 0},
    {'1': 'SENDING', '2': 1},
    {'1': 'SENT', '2': 2},
    {'1': 'SEEN', '2': 3},
    {'1': 'ERROR', '2': 4},
    {'1': 'CLEAR', '2': 5},
  ],
};

/// Descriptor for `ChatMessageStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatMessageStatusDescriptor = $convert.base64Decode(
    'ChFDaGF0TWVzc2FnZVN0YXR1cxIICgRJTklUEAASCwoHU0VORElORxABEggKBFNFTlQQAhIICg'
    'RTRUVOEAMSCQoFRVJST1IQBBIJCgVDTEVBUhAF');

