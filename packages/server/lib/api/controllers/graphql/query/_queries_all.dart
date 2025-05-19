import 'package:graphql_schema2/graphql_schema2.dart';

import 'query_invitation.dart';
import 'query_version.dart';

List<GraphQLObjectField<dynamic, dynamic>> get queriesAll => [
  ...QueryInvitation().all,
  queryVersion,
];
