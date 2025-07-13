// This is a generated file - do not edit.
//
// Generated from chat/chat_update_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chatUpdateMessageRequestDescriptor instead')
const ChatUpdateMessageRequest$json = {
  '1': 'ChatUpdateMessageRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 12, '10': 'clientId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.tentura.chat.ChatMessageStatus', '10': 'status'},
  ],
};

/// Descriptor for `ChatUpdateMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatUpdateMessageRequestDescriptor = $convert.base64Decode(
    'ChhDaGF0VXBkYXRlTWVzc2FnZVJlcXVlc3QSGwoJY2xpZW50X2lkGAEgASgMUghjbGllbnRJZB'
    'I3CgZzdGF0dXMYAiABKA4yHy50ZW50dXJhLmNoYXQuQ2hhdE1lc3NhZ2VTdGF0dXNSBnN0YXR1'
    'cw==');

@$core.Deprecated('Use chatUpdateMessageResponseDescriptor instead')
const ChatUpdateMessageResponse$json = {
  '1': 'ChatUpdateMessageResponse',
  '2': [
    {'1': 'updated_at', '3': 1, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `ChatUpdateMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatUpdateMessageResponseDescriptor = $convert.base64Decode(
    'ChlDaGF0VXBkYXRlTWVzc2FnZVJlc3BvbnNlEh0KCnVwZGF0ZWRfYXQYASABKANSCXVwZGF0ZW'
    'RBdA==');

