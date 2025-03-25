import 'package:get_it/get_it.dart';
import 'package:graphql_schema2/graphql_schema2.dart';

import 'package:tentura_server/domain/entity/jwt_entity.dart';
import 'package:tentura_server/domain/exception.dart';
import 'package:tentura_server/domain/use_case/user_case.dart';

import '../input_types.dart';

GraphQLObjectField<dynamic, dynamic> get userDelete => GraphQLObjectField(
  'deleteUser',
  graphQLBoolean.nonNullable(),
  resolve: (_, args) async {
    final jwt = args[JwtEntity.key] as JwtEntity?;

    if (jwt == null) {
      throw const UnauthorizedException();
    }

    return GetIt.I<UserCase>().deleteById(
      id: args[kInputTypeIdFieldName] as String,
    );
  },
);
