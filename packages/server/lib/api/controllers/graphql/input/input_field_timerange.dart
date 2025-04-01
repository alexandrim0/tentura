part of '_input_types.dart';

abstract class InputFieldTimerange {
  static final field = GraphQLFieldInput(_fieldKey, type);

  static final type = GraphQLInputObjectType(
    'TimeRange',
    inputFields: [
      GraphQLInputObjectField('from', graphQLDate),
      GraphQLInputObjectField('to', graphQLDate),
    ],
  );

  static ({DateTime? from, DateTime? to})? fromArgs(Map<String, dynamic> args) {
    final field = args[_fieldKey] as Map<String, dynamic>?;
    if (field == null) {
      return null;
    }
    final from = DateTime.tryParse((field['from'] ?? '') as String);
    final to = DateTime.tryParse((field['to'] ?? '') as String);
    return (from: from, to: to);
  }

  static const _fieldKey = 'timeRange';
}
