import 'package:ferry/ferry.dart';
import 'package:gql_exec/gql_exec.dart';

class AuthLink extends Link {
  const AuthLink(this._getToken);

  final Future<String?> Function() _getToken;

  @override
  Stream<Response> request(
    Request request, [
    NextLink? forward,
  ]) async* {
    assert(forward != null, 'NextLink forward is null!');
    final token = await _getToken();
    yield* token == null
        ? forward!(request)
        : forward!(Request(
            operation: request.operation,
            variables: request.variables,
            context: request.context.updateEntry<HttpLinkHeaders>(
              (headers) => HttpLinkHeaders(
                headers: {
                  ...?headers?.headers,
                  'Authorization': 'Bearer $token',

                  // TBD: move to separated Link?
                  // if (request.operation.getOperationType() ==
                  //         OperationType.query &&
                  //     request.variables.containsKey('context'))
                  //   'X-Hasura-Query-Context':
                  //       request.variables['context'].toString(),
                },
              ),
            ),
          ));
  }
}
