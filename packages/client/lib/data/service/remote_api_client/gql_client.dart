import 'dart:async';
import 'dart:developer';
import 'package:ferry/ferry.dart'
    show Cache, Client, FetchPolicy, Link, MemoryStore, NextLink, OperationType;
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_error_link/gql_error_link.dart';
import 'package:gql_dedupe_link/gql_dedupe_link.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';

import 'package:tentura_root/consts.dart';

class AuthLink extends Link {
  const AuthLink(this._getToken);

  final Future<String?> Function() _getToken;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    assert(forward != null, 'NextLink forward is null!');
    final token = await _getToken();
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
                  'Authorization': 'Bearer $token',
                },
              ),
            ),
          ),
        );
  }
}

typedef ClientParams = ({String serverUrl, String userAgent});

Future<Client> buildClient({
  required ClientParams params,
  required Future<String?> Function() getToken,
}) async => Client(
  cache: Cache(store: MemoryStore()),
  defaultFetchPolicies: {OperationType.query: FetchPolicy.NoCache},
  link: Link.from([
    DedupeLink(),

    AuthLink(getToken),

    ErrorLink(
      onException: (request, forward, exception) {
        log(exception.toString());
        return null;
      },
      onGraphQLError: (request, forward, response) {
        log(response.errors.toString());
        return null;
      },
    ),

    Link.split(
      (Request request) =>
          request.operation.getOperationType() == OperationType.subscription,
      TransportWebSocketLink(
        TransportWsClientOptions(
          connectionParams:
              () async => {
                'headers': {
                  kHeaderUserAgent: params.userAgent,
                  kHeaderContentType: kContentApplicationJson,
                  kHeaderAuthorization: 'Bearer ${await getToken()}',
                },
              },

          socketMaker: WebSocketMaker.url(
            () =>
                Uri.parse(
                  params.serverUrl,
                ).replace(port: 443, scheme: 'wss').toString(),
          ),
          shouldRetry: (_) => true,
          log: log,
        ),
      ),
      HttpLink(
        params.serverUrl,
        defaultHeaders: {
          kHeaderAccept: kContentApplicationJson,
          kHeaderUserAgent: params.userAgent,
        },
      ),
    ),
  ]),
);
