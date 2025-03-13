import 'package:graphql_schema2/graphql_schema2.dart';
import 'package:graphql_server2/graphql_server2.dart';

import 'custom_types.dart';
import 'mutation/mutation_auth.dart';
import 'mutation/mutation_beacon.dart';
import 'query/query_version.dart';

export 'package:graphql_schema2/graphql_schema2.dart';

GraphQL get graphqlSchema => GraphQL(
  GraphQLSchema(
    queryType: GraphQLObjectType('Query', 'Query root')
      ..fields.addAll([
        // Version
        queryVersion,
      ]),
    mutationType: GraphQLObjectType('Mutation', 'Mutation root')
      ..fields.addAll([
        // Auth
        signIn,
        signUp,
        signOut,

        // Beacon
        beaconBeleteById,
      ]),
  ),
  customTypes: customTypes,
);
