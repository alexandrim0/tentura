import 'dart:async';
import 'package:ferry/ferry.dart' show OperationResponse;
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';

import 'remote_api_client/exception.dart';
import 'remote_api_client/remote_api_client_web.dart';
// import 'remote_api_client/remote_api_client_native.dart'
//     if (dart.library.js_interop) 'remote_api_client/remote_api_client_web.dart';

export 'package:ferry/ferry.dart'
    show DataSource, FetchPolicy, OperationResponse;
export 'package:gql_exec/gql_exec.dart' show Context, HttpLinkHeaders;
export 'package:web_socket_client/src/connection_state.dart';

export 'remote_api_client/auth_link.dart' show AuthHeaderMode, HttpAuthHeaders;
export 'remote_api_client/remote_api_client_base.dart';

@singleton
final class RemoteApiService extends RemoteApiClient {
  RemoteApiService()
    : super(
        userAgent: kUserAgent,
        apiEndpointUrl: kServerName + kPathGraphQLEndpoint,
        wsEndpointUrl: kServerName + kPathWebSocketEndpoint,
        requestTimeout: const Duration(seconds: kRequestTimeout),
        authJwtExpiresIn: const Duration(seconds: kAuthJwtExpiresIn),
        wsPingInterval: kWsPingInterval,
      );

  @override
  @disposeMethod
  Future<void> close() async {
    await super.close();
  }
}

extension ErrorHandler<TData, TVars> on OperationResponse<TData, TVars> {
  TData dataOrThrow({String? label}) {
    if (hasErrors) {
      throw GraphQLException(
        error: linkException ?? graphqlErrors,
        label: label,
      );
    }
    if (data == null) throw GraphQLNoDataException(label: label);

    return data!;
  }
}
