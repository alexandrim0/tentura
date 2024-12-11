import 'dart:isolate';
import 'package:ferry/ferry.dart' show Client, FetchPolicy, Link, OperationType;
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_dedupe_link/gql_dedupe_link.dart';
import 'package:gql_websocket_link/gql_websocket_link.dart';

import 'auth_link.dart';
import 'error_link.dart';
import 'message.dart';

Future<Client> buildClient(
  ({
    bool isDebugMode,
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
    link: Link.from([
      DedupeLink(),

      //
      AuthLink(() async {
        sendPort.send(GetTokenRequest());
        final response = await tokenStream
            .where((e) => e is GetTokenResponse)
            .first as GetTokenResponse;
        return response.value;
      }),

      //
      if (params.isDebugMode) buildErrorLink(),

      //
      Link.split(
        (Request request) =>
            request.operation.getOperationType() == OperationType.subscription,

        //
        TransportWebSocketLink(
          TransportWsClientOptions(
            shouldRetry: (_) => true,
            log: params.isDebugMode ? print : null,
            connectionParams: () async {
              sendPort.send(GetTokenRequest());
              final token = await tokenStream
                  .where((e) => e is GetTokenResponse)
                  .first as GetTokenResponse;
              return Future.value({
                'headers': {
                  'content-type': 'application/json',
                  'Authorization': 'Bearer ${token.value}'
                },
              });
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

        //
        HttpLink(
          params.serverUrl,
          defaultHeaders: {
            'accept': 'application/json',
            'user-agent': params.userAgent,
          },
        ),
      ),
    ]),

    //
    defaultFetchPolicies: {
      OperationType.query: FetchPolicy.NoCache,
    },
  );
}
