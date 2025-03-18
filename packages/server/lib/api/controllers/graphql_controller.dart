import 'dart:convert';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/consts.dart';
import 'package:tentura_server/domain/exception.dart';

import 'graphql/schema.dart';
import '_base_controller.dart';

@Injectable(order: 3)
final class GraphqlController extends BaseController {
  const GraphqlController(super.env);

  @override
  Future<Response> handler(Request request) async {
    try {
      final requestJson = await request.body.asJson as Map<String, dynamic>;
      final response = await (env.kDebugMode ? graphqlSchema : _graphqlSchema)
          .parseAndExecute(
            operationName: requestJson['operationName'] as String?,
            requestJson['query'] as String? ?? '',
            variableValues:
                (requestJson['variables'] as Map<String, dynamic>?) ?? {},
            globalVariables: {
              'userId': request.context['userId'],
              'userRole': request.context['userRole'],
              'queryContext': request.headers[kHeaderQueryContext],
            },
          );

      switch (response) {
        case final Map<String, dynamic> query:
          return Response.ok(jsonEncode({'data': query}));

        case final Stream<Map<String, dynamic>> _:
          throw UnimplementedError();

        default:
          throw Exception('Unexpected type');
      }
    } on GraphQLException catch (e) {
      return Response.ok(jsonEncode(e.toJson()));
    } on ExceptionBase catch (e) {
      return Response.ok(
        jsonEncode({
          'errors': [e.toMap],
        }),
      );
    } catch (e) {
      return Response.ok(
        jsonEncode({
          'errors': [
            {'message': e.toString()},
          ],
        }),
      );
    }
  }

  static final _graphqlSchema = graphqlSchema;
}
