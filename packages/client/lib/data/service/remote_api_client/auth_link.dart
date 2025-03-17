import 'dart:async';
import 'package:ferry/ferry.dart' show Link, NextLink;
import 'package:gql_exec/gql_exec.dart';

enum AuthHeaderMode { anon, bearer }

class HttpAuthHeaders extends ContextEntry {
  const HttpAuthHeaders({this.authHeaderMode = AuthHeaderMode.bearer});

  const HttpAuthHeaders.noAuth() : authHeaderMode = AuthHeaderMode.anon;

  final AuthHeaderMode authHeaderMode;

  @override
  List<Object> get fieldsForEquality => [authHeaderMode];

  bool get isAnon => authHeaderMode == AuthHeaderMode.anon;

  bool get withAuth => authHeaderMode == AuthHeaderMode.bearer;
}

class AuthLink extends Link {
  const AuthLink(this._getToken);

  final Future<String?> Function() _getToken;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    assert(forward != null, 'NextLink forward is null!');
    final withAuth = request.context.entry<HttpAuthHeaders>()?.withAuth ?? true;
    final token = withAuth ? await _getToken() : null;
    yield* token == null
        ? forward!(request)
        : forward!(
          Request(
            operation: request.operation,
            variables: request.variables,
            context: request.context.updateEntry<HttpLinkHeaders>(
              (headers) => HttpLinkHeaders(
                headers: {
                  ...?headers?.headers,
                  if (withAuth) 'Authorization': 'Bearer $token',
                },
              ),
            ),
          ),
        );
  }
}
