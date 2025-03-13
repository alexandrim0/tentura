import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/use_case/auth_case.dart';

import '../custom_types.dart';
import '../input_types.dart';

GraphQLObjectField<dynamic, dynamic> get signIn => GraphQLObjectField(
  'signIn',
  gqlTypeAuthResponse.nonNullable(),
  arguments: [gqlInputTypeAuthRequestToken],
  resolve: (_, args) async {
    final jwt = await GetIt.I<AuthCase>().signIn(
      authRequestToken: args[kInputTypeAuthRequestToken] as String,
    );
    return jwt.asOauth2Map;
  },
);

GraphQLObjectField<dynamic, dynamic> get signUp => GraphQLObjectField(
  'signUp',
  gqlTypeAuthResponse.nonNullable(),
  arguments: [
    gqlInputTypeTitle,
    gqlInputTypeDescription,
    gqlInputTypeAuthRequestToken,
  ],
  resolve: (_, args) async {
    final jwt = await GetIt.I<AuthCase>().signUp(
      authRequestToken: args[kInputTypeAuthRequestToken] as String,
      description: args[kInputTypeDescriptionFieldName] as String?,
      title: args[kInputTypeTitleFieldName] as String?,
    );
    return jwt.asOauth2Map;
  },
);

GraphQLObjectField<dynamic, dynamic> get signOut => GraphQLObjectField(
  'signOut',
  graphQLBoolean.nonNullable(),
  resolve: (_, _) => true,
);
