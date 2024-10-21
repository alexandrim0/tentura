import 'dart:isolate';
import 'package:ferry/ferry.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';

import 'auth_link.dart';
import 'message.dart';

Future<Client> buildClient(
  ({
    String userAgent,
    String serverUrl,
    String? storagePath,
  }) params,
  SendPort? sendPort,
) async {
  final receivePort = ReceivePort();
  sendPort!.send(InitMessage(receivePort.sendPort));
  final tokenStream = receivePort.asBroadcastStream();
  return Client(
    link: Link.concat(
      AuthLink(() async {
        sendPort.send(GetTokenRequest());
        final response = await tokenStream
            .where((e) => e is GetTokenResponse)
            .first as GetTokenResponse;
        return response.value;
      }),
      Link.split(
          (Request request) =>
              request.operation.getOperationType() ==
              OperationType.subscription,
          TransportWebSocketLink(
            TransportWsClientOptions(
              connectionParams: () async {
                sendPort.send(GetTokenRequest());
                final token = await tokenStream
                    .where((e) => e is GetTokenResponse)
                    .first as GetTokenResponse;
                return {
                  'headers': {
                    'content-type': 'application/json',
                    'Authorization': 'Bearer ${token.value}'
                  },
                };
              },
              socketMaker: WebSocketMaker.url(
                () => Uri.parse(params.serverUrl)
                    .replace(
                      port: 443,
                      scheme: 'wss',
                    )
                    .toString(),
              ),
            ),
          ),
          HttpLink(
            params.serverUrl,
            defaultHeaders: {
              'accept': 'application/json',
              'user-agent': params.userAgent,
            },
          )),
    ),
    defaultFetchPolicies: {
      OperationType.query: FetchPolicy.NoCache,
    },
  );
}
