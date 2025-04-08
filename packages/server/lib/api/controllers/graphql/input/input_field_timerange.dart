part of '_input_types.dart';

abstract class InputFieldTimerange {
  static final field = GraphQLFieldInput(
    _fieldKey,
    type,
    defaultValue: <String, dynamic>{},
  );

  static final type = GraphQLInputObjectType(
    'DateRange',
    inputFields: [
      GraphQLInputObjectField('start', graphQLString),
      GraphQLInputObjectField('end', graphQLString),
    ],
  );

  static DateRange? fromArgs(Map<String, dynamic> args) =>
      switch (args[_fieldKey]) {
        final Map<String, dynamic> field when field.isNotEmpty =>
          DateRange.fromJson(field),
        _ => null,
      };

  static const _fieldKey = 'dateRange';
}
