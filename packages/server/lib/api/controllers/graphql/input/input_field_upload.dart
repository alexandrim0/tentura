part of '_input_types.dart';

abstract class InputFieldUpload {
  static final field = GraphQLFieldInput(
    _fieldKey,
    type,
    defaultValue: <String, dynamic>{},
  );

  static final fieldImage = GraphQLFieldInput(
    _fieldImageKey,
    type,
    defaultValue: <String, dynamic>{},
  );

  static final type = GraphQLInputObjectType(
    'Upload',
    inputFields: [
      GraphQLInputObjectField('filename', graphQLString),
      GraphQLInputObjectField('type', graphQLString),
    ],
  );

  static Stream<Uint8List>? fromArgs(Map<String, dynamic> args) =>
      args[kGlobalInputQueryFile] as Stream<Uint8List>?;

  static const _fieldKey = 'file';

  static const _fieldImageKey = 'image';
}
