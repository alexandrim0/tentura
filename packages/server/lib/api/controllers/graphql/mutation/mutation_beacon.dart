import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/use_case/beacon_case.dart';

import '../custom_types.dart';
import '../input/_input_types.dart';

GraphQLObjectField<dynamic, dynamic> get beaconBeleteById => GraphQLObjectField(
  'beaconDeleteById',
  graphQLBoolean.nonNullable(),
  arguments: [InputFieldId.fieldNonNullable],
  resolve:
      (_, args) => switch (args[kGlobalInputQueryJwt]) {
        final JwtEntity jwt => GetIt.I<BeaconCase>().deleteById(
          beaconId: InputFieldId.fromArgsNonNullable(args),
          userId: jwt.sub,
        ),
        _ => throw const UnauthorizedException(),
      },
);

GraphQLObjectField<dynamic, dynamic> get beaconCreate => GraphQLObjectField(
  'beaconCreate',
  gqlTypeBeacon.nonNullable(),
  arguments: [
    InputFieldContext.field,
    InputFieldDescription.field,
    InputFieldCoordinates.field,
    InputFieldUpload.fieldImage,
    InputFieldTitle.fieldNonNullable,
    InputFieldStartAt.field,
    InputFieldEndAt.field,
  ],
  resolve:
      (_, args) => switch (args[kGlobalInputQueryJwt]) {
        final JwtEntity jwt => GetIt.I<BeaconCase>()
            .create(
              userId: jwt.sub,
              description: InputFieldDescription.fromArgs(args),
              title: InputFieldTitle.fromArgsNonNullable(args),
              coordinates: InputFieldCoordinates.fromArgs(args),
              imageBytes: InputFieldUpload.fromArgs(args),
              context: InputFieldContext.fromArgs(args),
              startAt: InputFieldStartAt.fromArgs(args),
              endAt: InputFieldEndAt.fromArgs(args),
            )
            .then((v) => v.asJson),
        _ => throw const UnauthorizedException(),
      },
);
