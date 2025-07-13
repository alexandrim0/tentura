// This is a generated file - do not edit.
//
// Generated from chat/chat_send_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chatSendMessageRequestDescriptor instead')
const ChatSendMessageRequest$json = {
  '1': 'ChatSendMessageRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 12, '10': 'clientId'},
    {'1': 'receiver', '3': 2, '4': 1, '5': 9, '10': 'receiver'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `ChatSendMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatSendMessageRequestDescriptor = $convert.base64Decode(
    'ChZDaGF0U2VuZE1lc3NhZ2VSZXF1ZXN0EhsKCWNsaWVudF9pZBgBIAEoDFIIY2xpZW50SWQSGg'
    'oIcmVjZWl2ZXIYAiABKAlSCHJlY2VpdmVyEhgKB2NvbnRlbnQYAyABKAlSB2NvbnRlbnQ=');

@$core.Deprecated('Use chatSendMessageResponseDescriptor instead')
const ChatSendMessageResponse$json = {
  '1': 'ChatSendMessageResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 12, '10': 'serverId'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `ChatSendMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatSendMessageResponseDescriptor = $convert.base64Decode(
    'ChdDaGF0U2VuZE1lc3NhZ2VSZXNwb25zZRIbCglzZXJ2ZXJfaWQYASABKAxSCHNlcnZlcklkEh'
    '0KCmNyZWF0ZWRfYXQYAiABKANSCWNyZWF0ZWRBdA==');

