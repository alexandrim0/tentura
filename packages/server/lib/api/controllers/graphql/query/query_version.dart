import 'package:graphql_schema2/graphql_schema2.dart';

GraphQLObjectField<dynamic, dynamic> get queryVersion => GraphQLObjectField(
  'version',
  graphQLString.nonNullable(),
  resolve: (_, _) => '0.2.2',
);
