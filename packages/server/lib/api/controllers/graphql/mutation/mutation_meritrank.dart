import 'package:tentura_server/domain/use_case/meritrank_case.dart';

import '../gql_nodel_base.dart';

final class MutationMeritrank extends GqlNodeBase {
  MutationMeritrank({MeritrankCase? meritrankCase})
    : _meritrankCase = meritrankCase ?? GetIt.I<MeritrankCase>();

  final MeritrankCase _meritrankCase;

  List<GraphQLObjectField<dynamic, dynamic>> get all => [meritrankInit];

  GraphQLObjectField<dynamic, dynamic> get meritrankInit => GraphQLObjectField(
    'meritrankInit',
    graphQLInt.nonNullable(),
    resolve: (_, args) {
      final credentials = getCredentials(args);
      return _meritrankCase.init(
        userId: credentials.sub,
        userRoles: credentials.roles,
      );
    },
  );
}
