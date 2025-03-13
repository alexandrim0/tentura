import 'package:graphql_schema2/graphql_schema2.dart';

List<GraphQLObjectField<dynamic, dynamic>> get queryFields => [
  GraphQLObjectField(
    'version',
    graphQLString.nonNullable(),
    resolve: (_, _) => '0.1.0',
  ),
];
