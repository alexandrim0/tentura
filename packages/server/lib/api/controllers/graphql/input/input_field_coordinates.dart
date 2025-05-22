part of '_input_types.dart';

abstract class InputFieldCoordinates {
  static final field = GraphQLFieldInput(
    _fieldKey,
    type,
    defaultValue: <String, dynamic>{},
  );

  static final type = GraphQLInputObjectType(
    'Coordinates',
    inputFields: [
      GraphQLInputObjectField('lat', graphQLFloat),
      GraphQLInputObjectField('long', graphQLFloat),
    ],
  );

  static Coordinates? fromArgs(Map<String, dynamic> args) =>
      switch (args[_fieldKey]) {
        final Map<String, dynamic> field when field.isNotEmpty => Coordinates(
          lat: field['lat']! as double,
          long: field['long']! as double,
        ),
        _ => null,
      };

  static const _fieldKey = 'coordinates';
}
