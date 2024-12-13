import 'dart:async';
import 'package:ferry/ferry.dart'
    show Cache, Client, FetchPolicy, Link, MemoryStore, OperationType;
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_dedupe_link/gql_dedupe_link.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';

import 'auth_link.dart';
import 'error_link.dart';
import 'message.dart';

Future<Client> buildClient({
  required String serverUrl,
  required Future<GetTokenResponse> Function() getToken,
  bool isDebugMode = false,
}) async =>
    Client(
      cache: Cache(
        store: MemoryStore(),
      ),

      //
      defaultFetchPolicies: {
        OperationType.query: FetchPolicy.NoCache,
      },

      //
      link: Link.from([
        DedupeLink(),

        //
        AuthLink(() => getToken().then((v) => v.value)),

        //
        if (isDebugMode) buildErrorLink(),

        //
        Link.split(
            (Request request) =>
                request.operation.getOperationType() ==
                OperationType.subscription,

            //
            TransportWebSocketLink(
              TransportWsClientOptions(
                shouldRetry: (_) => true,
                log: isDebugMode ? print : null,
                connectionParams: () async {
                  final token = await getToken();
                  return Future.value({
                    'headers': {
                      'content-type': 'application/json',
                      'Authorization': 'Bearer ${token.value}'
                    },
                  });
                },
                socketMaker: WebSocketMaker.url(
                  () => Uri.parse(serverUrl)
                      .replace(
                        port: 443,
                        scheme: 'wss',
                      )
                      .toString(),
                ),
              ),
            ),

            //
            HttpLink(
              serverUrl,
              defaultHeaders: {
                'accept': 'application/json',
              },
            )),
      ]),
    );
