import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura_sdk/tentura_sdk.dart';

export 'package:tentura_sdk/tentura_sdk.dart';

@singleton
class RemoteApiService extends TenturaApi {
  @FactoryMethod(preResolve: true)
  static Future<RemoteApiService> create() async {
    final api = RemoteApiService();
    await api.init();
    return api;
  }

  RemoteApiService({
    super.storagePath = '',
    super.userAgent = kUserAgent,
    super.isDebugMode = kDebugMode,
    super.apiUrlBase = kAppLinkBase,
    super.jwtExpiresIn = kJwtExpiresIn,
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
