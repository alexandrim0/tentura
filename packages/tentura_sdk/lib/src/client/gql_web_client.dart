import 'dart:async';
import 'package:ferry/ferry.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';

import 'auth_link.dart';
import 'message.dart';

Future<Client> buildClient({
  required String serverUrl,
  required Future<GetTokenResponse> Function() getToken,
}) async =>
    Client(
      link: Link.concat(
        AuthLink(() => getToken().then((v) => v.value)),
        Link.split(
            (Request request) =>
                request.operation.getOperationType() ==
                OperationType.subscription,
            TransportWebSocketLink(
              TransportWsClientOptions(
                connectionParams: () async {
                  final token = await getToken();
                  return {
                    'headers': {
                      'content-type': 'application/json',
                      'Authorization': 'Bearer ${token.value}'
                    },
                  };
                },
                socketMaker: WebSocketMaker.url(
                  () => Uri.parse(serverUrl).replace(scheme: 'wss').toString(),
                ),
              ),
            ),
            HttpLink(
              serverUrl,
              defaultHeaders: {
                'accept': 'application/json',
              },
            )),
      ),
      defaultFetchPolicies: {
        OperationType.query: FetchPolicy.NoCache,
      },
    );
