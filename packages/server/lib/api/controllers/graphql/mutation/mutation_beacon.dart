import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/use_case/beacon_mutation_case.dart';

import '../input_types.dart';

GraphQLObjectField<dynamic, dynamic> get beaconBeleteById => GraphQLObjectField(
  'delete_beacon_by_id',
  graphQLBoolean.nonNullable(),
  arguments: [gqlInputTypeId],
  resolve:
      (_, args) async => GetIt.I<BeaconMutationCase>().deleteById(
        beaconId: args[kInputTypeIdFieldName] as String,
        userId: args[kInputTypeIdFieldName] as String,
      ),
);
