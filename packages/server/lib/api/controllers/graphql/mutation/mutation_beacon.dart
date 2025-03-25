import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/use_case/beacon_case.dart';

import '../input_types.dart';

GraphQLObjectField<dynamic, dynamic> get beaconBeleteById => GraphQLObjectField(
  'beaconDeleteById',
  graphQLBoolean.nonNullable(),
  arguments: [gqlInputTypeId],
  resolve:
      (_, args) => switch (args[kGlobalInputQueryJwt]) {
        final JwtEntity jwt => GetIt.I<BeaconCase>().deleteById(
          beaconId: args[kInputTypeIdFieldName] as String,
          userId: jwt.sub,
        ),
        _ => throw const UnauthorizedException(),
      },
);
