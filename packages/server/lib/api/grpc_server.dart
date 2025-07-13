import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura_server/env.dart';

import 'controllers/grpc/chat_service.dart';
import 'middleware/auth_middleware.dart';

@Injectable(order: 4)
class GrpcServer {
  GrpcServer(
    this._env,
    this._authMiddleware,
    this._chatService,
  );

  final Env _env;

  final ChatService _chatService;

  final AuthMiddleware _authMiddleware;

  late final _grpcServer = Server.create(
    codecRegistry: CodecRegistry(
      codecs: [
        if (_env.isDebugModeOn) const IdentityCodec() else const GzipCodec(),
      ],
    ),
    interceptors: [
      logInterceptor,
      _authMiddleware.authInterceptor,
    ],
    services: [
      _chatService,
    ],
  );

  Future<void> serve() => _grpcServer.serve(
    address: _env.bindAddress,
    port: _env.listenGrpcPort,
    shared: true,
  );

  Future<void> shutdown() => _grpcServer.shutdown();

  Future<GrpcError?> logInterceptor(
    ServiceCall call,
    ServiceMethod<dynamic, dynamic> method,
  ) async {
    print('Method: [${method.name}]');
    print('Client Metadata: [${call.clientMetadata}]');
    return null;
  }
}
