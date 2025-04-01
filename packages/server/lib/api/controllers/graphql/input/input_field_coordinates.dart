part of '_input_types.dart';

abstract class InputFieldCoordinates {
  static final field = GraphQLFieldInput(_fieldKey, type);

  static final type = GraphQLInputObjectType(
    'Coordinates',
    inputFields: [
      GraphQLInputObjectField('lat', graphQLFloat),
      GraphQLInputObjectField('long', graphQLFloat),
    ],
  );

  static ({double lat, double long})? fromArgs(Map<String, dynamic> args) {
    final field = args[_fieldKey] as Map<String, dynamic>?;
    if (field == null) {
      return null;
    }
    final lat = field['lat'] as double?;
    final long = field['long'] as double?;
    if (lat == null || long == null) {
      return null;
    }
    return (lat: lat, long: long);
  }

  static const _fieldKey = 'coordinates';
}
