part of '_input_types.dart';

abstract class InputFieldEndAt {
  static final field = GraphQLFieldInput(
    _fieldKey,
    graphQLString,
    defaultsToNull: true,
  );

  static DateTime? fromArgs(Map<String, dynamic> args) =>
      switch (args[_fieldKey]) {
        final String field when field.isNotEmpty => DateTime.tryParse(field),
        _ => null,
      };

  static const _fieldKey = 'endAt';
}
