import 'package:tentura_server/domain/use_case/auth_case.dart';

import '../custom_types.dart';
import '../gql_nodel_base.dart';
import '../input/_input_types.dart';

final class MutationAuth extends GqlNodeBase {
  MutationAuth({AuthCase? authCase})
    : _authCase = authCase ?? GetIt.I<AuthCase>();

  final AuthCase _authCase;

  final _authRequestToken = InputFieldString(fieldName: 'authRequestToken');

  List<GraphQLObjectField<dynamic, dynamic>> get all => [
    signIn,
    signUp,
    signOut,
  ];

  GraphQLObjectField<dynamic, dynamic> get signIn => GraphQLObjectField(
    'signIn',
    gqlTypeAuthResponse.nonNullable(),
    arguments: [_authRequestToken.field],
    resolve: (_, args) async {
      final jwt = await _authCase.signIn(
        authRequestToken: _authRequestToken.fromArgsNonNullable(args),
      );
      return jwt.asOauth2Map;
    },
  );

  GraphQLObjectField<dynamic, dynamic> get signUp => GraphQLObjectField(
    'signUp',
    gqlTypeAuthResponse.nonNullable(),
    arguments: [InputFieldTitle.fieldNonNullable, _authRequestToken.field],
    resolve: (_, args) async {
      final jwt = await _authCase.signUp(
        authRequestToken: _authRequestToken.fromArgsNonNullable(args),
        title: InputFieldTitle.fromArgsNonNullable(args),
      );
      return jwt.asOauth2Map;
    },
  );

  GraphQLObjectField<dynamic, dynamic> get signOut => GraphQLObjectField(
    'signOut',
    graphQLBoolean.nonNullable(),
    resolve: (_, args) => _authCase.signOut(jwt: getCredentials(args)),
  );
}
