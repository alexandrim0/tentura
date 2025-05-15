import 'package:graphql_schema2/graphql_schema2.dart';
import 'package:graphql_server2/graphql_server2.dart';

import 'custom_types.dart';
import 'mutation/_mutations_all.dart';
import 'query/_queries_all.dart';

export 'package:graphql_schema2/graphql_schema2.dart';

GraphQL get graphqlSchema => GraphQL(
  GraphQLSchema(
    queryType: GraphQLObjectType('Query', 'Query root')
      ..fields.addAll(queriesAll),
    mutationType: GraphQLObjectType('Mutation', 'Mutation root')
      ..fields.addAll(mutationsAll),
  ),
  customTypes: customTypes,
);
