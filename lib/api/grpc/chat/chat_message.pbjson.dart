// This is a generated file - do not edit.
//
// Generated from chat/chat_message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 12, '10': 'clientId'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 12, '10': 'serverId'},
    {'1': 'sender', '3': 3, '4': 1, '5': 9, '10': 'sender'},
    {'1': 'receiver', '3': 4, '4': 1, '5': 9, '10': 'receiver'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 7, '4': 1, '5': 3, '10': 'updatedAt'},
    {'1': 'status', '3': 8, '4': 1, '5': 14, '6': '.tentura.chat.ChatMessageStatus', '10': 'status'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIbCgljbGllbnRfaWQYASABKAxSCGNsaWVudElkEhsKCXNlcnZlcl9pZB'
    'gCIAEoDFIIc2VydmVySWQSFgoGc2VuZGVyGAMgASgJUgZzZW5kZXISGgoIcmVjZWl2ZXIYBCAB'
    'KAlSCHJlY2VpdmVyEhgKB2NvbnRlbnQYBSABKAlSB2NvbnRlbnQSHQoKY3JlYXRlZF9hdBgGIA'
    'EoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYByABKANSCXVwZGF0ZWRBdBI3CgZzdGF0dXMY'
    'CCABKA4yHy50ZW50dXJhLmNoYXQuQ2hhdE1lc3NhZ2VTdGF0dXNSBnN0YXR1cw==');

