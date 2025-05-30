import 'dart:async';
import 'dart:developer';
import 'package:ferry/ferry.dart' show Client, FetchPolicy, Link, OperationType;
// show Cache, Client, FetchPolicy, Link, MemoryStore, OperationType;
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_error_link/gql_error_link.dart';
import 'package:gql_dedupe_link/gql_dedupe_link.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';

import 'package:tentura_root/consts.dart';

import 'auth_link.dart';

typedef ClientParams =
    ({String apiEndpointUrl, String userAgent, Duration requestTimeout});

Future<Client> buildClient({
  required ClientParams params,
  required Future<String?> Function() getToken,
}) async => Client(
  // cache: Cache(store: MemoryStore()),
  defaultFetchPolicies: {OperationType.query: FetchPolicy.NoCache},
  link: Link.split(
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
                params.apiEndpointUrl,
              ).replace(port: 443, scheme: 'wss').toString(),
        ),
        shouldRetry: (_) => true,
        retryAttempts: 5,
        log: log,
      ),
    ),
    Link.from([
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

      HttpLink(
        params.apiEndpointUrl,
        defaultHeaders: {
          kHeaderAccept: kContentApplicationJson,
          kHeaderUserAgent: params.userAgent,
        },
      ),
    ]),
  ),
);
