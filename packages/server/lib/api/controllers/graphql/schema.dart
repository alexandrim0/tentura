import 'package:graphql_schema2/graphql_schema2.dart';
import 'package:graphql_server2/graphql_server2.dart';

import 'mutation_root.dart';
import 'query_root.dart';
import 'types.dart';

export 'package:graphql_schema2/graphql_schema2.dart';

GraphQL get graphqlSchema => GraphQL(
  GraphQLSchema(
    queryType: GraphQLObjectType('Query', 'Query root')
      ..fields.addAll(queryFields),
    mutationType: GraphQLObjectType('Mutation', 'Mutation root')
      ..fields.addAll(mutationField),
  ),
  customTypes: customTypes,
);
