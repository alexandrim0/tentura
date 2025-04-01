import 'package:graphql_schema2/graphql_schema2.dart';

import 'input/_input_types.dart';

List<GraphQLType<dynamic, dynamic>> get customTypes => [
  InputFieldUpload.type,
  InputFieldTimerange.type,
  InputFieldCoordinates.type,
  gqlTypeAuthResponse,
  gqlTypeBeaconId,
];

final gqlTypeAuthResponse = GraphQLObjectType('AuthResponse', null)
  ..fields.addAll([
    field('subject', graphQLString.nonNullable()),
    field('expires_in', graphQLInt.nonNullable()),
    field('token_type', graphQLString.nonNullable()),
    field('access_token', graphQLString.nonNullable()),
    field('refresh_token', graphQLString),
  ]);

final gqlTypeBeaconId = GraphQLObjectType('Beacon', null)
  ..fields.addAll([field('id', graphQLString.nonNullable())]);
