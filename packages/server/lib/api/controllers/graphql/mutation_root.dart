import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/use_case/beacon_mutation_case.dart';

import 'types.dart';

List<GraphQLObjectField<dynamic, dynamic>> get mutationField => [
  // Auth
  GraphQLObjectField(
    'signOut',
    graphQLBoolean.nonNullable(),
    resolve: (_, _) => true,
  ),

  // Beacon
  GraphQLObjectField(
    'delete_beacon_by_id',
    graphQLBoolean.nonNullable(),
    arguments: [gqlInputTypeId],
    resolve:
        (_, args) async => GetIt.I<BeaconMutationCase>().deleteById(
          beaconId: args['id'] as String,
          userId: args['userId'] as String,
        ),
  ),
];
