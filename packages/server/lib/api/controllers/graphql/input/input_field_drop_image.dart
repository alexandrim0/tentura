part of '_input_types.dart';

abstract class InputFieldDropImage {
  static final field = GraphQLFieldInput(
    _fieldKey,
    graphQLBoolean,
    defaultsToNull: true,
  );

  static final fieldNonNullable = GraphQLFieldInput(
    _fieldKey,
    graphQLBoolean.nonNullable(),
    defaultValue: false,
  );

  static bool? fromArgs(Map<String, dynamic> args) => args[_fieldKey] as bool?;

  static bool fromArgsNonNullable(Map<String, dynamic> args) =>
      args[_fieldKey] as bool? ?? false;

  static const _fieldKey = 'dropImage';
}
