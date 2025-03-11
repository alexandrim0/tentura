import 'package:ferry/ferry.dart' show OperationResponse;
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';

import 'remote_api_client/exception.dart';
import 'remote_api_client/remote_api_client_native.dart'
    if (dart.library.js_interop) 'remote_api_client/remote_api_client_web.dart';

export 'package:ferry/ferry.dart'
    show DataSource, FetchPolicy, OperationResponse;
export 'package:gql_exec/gql_exec.dart' show Context, HttpLinkHeaders;

@singleton
final class RemoteApiService extends RemoteApiClient {
  @FactoryMethod(preResolve: true)
  static Future<RemoteApiService> create() async {
    final api = RemoteApiService();
    await api.init();
    return api;
  }

  RemoteApiService({
    super.userAgent = kUserAgent,
    super.apiUrlBase = kServerName,
    super.jwtExpiresIn = const Duration(seconds: kJwtExpiresIn),
    super.requestTimeout = const Duration(seconds: kRequestTimeout),
  });

  @disposeMethod
  Future<void> dispose() => close();
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
