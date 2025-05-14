part of '_input_types.dart';

abstract class InputFieldStartAt {
  static final GraphQLFieldInput<DateTime?, String?> field = GraphQLFieldInput(
    _fieldKey,
    graphQLDate,
    defaultsToNull: true,
  );

  static DateTime? fromArgs(Map<String, dynamic> args) =>
      switch (args[_fieldKey]) {
        final String field when field.isNotEmpty => DateTime.tryParse(field),
        _ => null,
      };

  static const _fieldKey = 'startAt';
}
