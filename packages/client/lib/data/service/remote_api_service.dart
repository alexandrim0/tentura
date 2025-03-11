import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';

import 'package:tentura_sdk/tentura_sdk.dart';

export 'package:tentura_sdk/tentura_sdk.dart';

@singleton
final class RemoteApiService extends TenturaApi {
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
