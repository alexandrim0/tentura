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
      GraphQLInputObjectField(_latitudeKey, graphQLFloat),
      GraphQLInputObjectField(_longitutdeKey, graphQLFloat),
    ],
  );

  static Coordinates? fromArgs(Map<String, dynamic> args) =>
      switch (args[_fieldKey]) {
        final Map<String, dynamic> field when field.isNotEmpty => Coordinates(
          lat: field[_latitudeKey]! as double,
          long: field[_longitutdeKey]! as double,
        ),
        _ => null,
      };

  static const _fieldKey = 'coordinates';

  static const _latitudeKey = 'lat';

  static const _longitutdeKey = 'long';
}
