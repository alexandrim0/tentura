import 'package:graphql_schema2/graphql_schema2.dart';

// Input fields
final gqlInputTypeId = GraphQLFieldInput(
  'id',
  graphQLNonEmptyString.nonNullable(),
);

final gqlInputTypeQueryContext = GraphQLFieldInput(
  'context',
  graphQLString,
  defaultsToNull: true,
);

// Custom types
final gqlTypeBeaconId = GraphQLObjectType('Beacon', null)
  ..fields.addAll([field('id', graphQLString.nonNullable())]);

List<GraphQLObjectType> get customTypes => [gqlTypeBeaconId];
