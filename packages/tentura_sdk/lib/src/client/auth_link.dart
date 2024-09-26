import 'package:ferry/ferry.dart' show Link, NextLink;
import 'package:gql_exec/gql_exec.dart' show HttpLinkHeaders, Request, Response;

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
                },
              ),
            ),
          ));
  }
}
