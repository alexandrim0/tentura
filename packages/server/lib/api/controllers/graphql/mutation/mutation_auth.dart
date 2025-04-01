import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/use_case/auth_case.dart';

import '../custom_types.dart';
import '../input/_input_types.dart';

GraphQLObjectField<dynamic, dynamic> get signIn => GraphQLObjectField(
  'signIn',
  gqlTypeAuthResponse.nonNullable(),
  arguments: [InputFieldAuthRequestToken.fieldNonNullable],
  resolve: (_, args) async {
    final jwt = await GetIt.I<AuthCase>().signIn(
      authRequestToken: InputFieldAuthRequestToken.fromArgsNonNullable(args),
    );
    return jwt.asOauth2Map;
  },
);

GraphQLObjectField<dynamic, dynamic> get signUp => GraphQLObjectField(
  'signUp',
  gqlTypeAuthResponse.nonNullable(),
  arguments: [
    InputFieldTitle.fieldNonNullable,
    InputFieldAuthRequestToken.fieldNonNullable,
  ],
  resolve: (_, args) async {
    final jwt = await GetIt.I<AuthCase>().signUp(
      authRequestToken: InputFieldAuthRequestToken.fromArgsNonNullable(args),
      title: InputFieldTitle.fromArgsNonNullable(args),
    );
    return jwt.asOauth2Map;
  },
);

GraphQLObjectField<dynamic, dynamic> get signOut => GraphQLObjectField(
  'signOut',
  graphQLBoolean.nonNullable(),
  resolve:
      (_, args) => switch (args[kGlobalInputQueryJwt]) {
        final JwtEntity _ => true,
        _ => throw const UnauthorizedException(),
      },
);
