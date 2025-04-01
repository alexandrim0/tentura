import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/use_case/user_case.dart';

import '../input/_input_types.dart';

GraphQLObjectField<dynamic, dynamic> get userUpdate => GraphQLObjectField(
  'userUpdate',
  graphQLBoolean.nonNullable(),
  arguments: [
    InputFieldTitle.field,
    InputFieldDescription.field,
    InputFieldDropImage.field,
    InputFieldUpload.field,
  ],
  resolve:
      (_, args) => switch (args[kGlobalInputQueryJwt]) {
        final JwtEntity jwt => GetIt.I<UserCase>().updateProfile(
          id: jwt.sub,
          title: InputFieldTitle.fromArgs(args),
          description: InputFieldDescription.fromArgs(args),
          imageBytes: InputFieldUpload.fromArgs(args),
          dropImage: InputFieldDropImage.fromArgs(args),
        ),
        _ => throw const UnauthorizedException(),
      },
);

GraphQLObjectField<dynamic, dynamic> get userDelete => GraphQLObjectField(
  'userDelete',
  graphQLBoolean.nonNullable(),
  resolve:
      (_, args) => switch (args[kGlobalInputQueryJwt]) {
        final JwtEntity jwt => GetIt.I<UserCase>().deleteById(id: jwt.sub),
        _ => throw const UnauthorizedException(),
      },
);
