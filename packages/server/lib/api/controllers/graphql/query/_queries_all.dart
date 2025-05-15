import 'package:graphql_schema2/graphql_schema2.dart';

import 'query_version.dart';

List<GraphQLObjectField<dynamic, dynamic>> get queriesAll => [
  // Version
  queryVersion,
];
