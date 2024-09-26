import 'package:injectable/injectable.dart';

import 'package:tentura/consts.dart';
import 'package:tentura_sdk/tentura_sdk.dart';

export 'package:tentura_sdk/tentura_sdk.dart' show DataSource;

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
    super.userAgent = kAppTitle,
    super.serverName = kAppLinkBase,
    super.jwtExpiresIn = kJwtExpiresIn,
  });

  @disposeMethod
  Future<void> dispose() => close();
}

extension ErrorHandler<TData, TVars> on OperationResponse<TData, TVars> {
  OperationResponse<TData, TVars> throwIfError({
    bool failOnNull = true,
    String? label,
  }) {
    if (hasErrors) {
      throw GraphQLException(
        error: linkException ?? graphqlErrors,
        label: label,
      );
    }
    if (failOnNull && data == null) {
      throw GraphQLNoDataException(label: label);
    }
    return this;
  }

  TData dataOrThrow({String? label}) => throwIfError(label: label).data!;
}
