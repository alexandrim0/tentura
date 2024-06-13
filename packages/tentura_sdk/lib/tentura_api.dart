import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:ferry/ferry.dart';
import 'package:ferry/ferry_isolate.dart';

import 'client/gql_client.dart';
import 'client/message.dart';
import 'service/image_service.dart';
import 'service/token_service.dart';

class TenturaApi {
  TenturaApi({
    required this.serverName,
    this.jwtExpiresIn = const Duration(minutes: 1),
    this.storagePath = '',
  })  : _imageService = ImageService(
          serverName: serverName,
        ),
        _tokenService = TokenService(
          serverName: serverName,
          jwtExpiresIn: jwtExpiresIn,
        );

  final String serverName;
  final String storagePath;
  final Duration jwtExpiresIn;

  final TokenService _tokenService;
  final ImageService _imageService;

  late final SendPort _replyPort;
  late final IsolateClient _gqlClient;

  String _userId = '';

  String get userId => _userId;

  Future<void> init() async {
    _gqlClient = await IsolateClient.create(
      buildClient,
      params: (
        serverName: serverName,
        storagePath: storagePath,
      ),
      messageHandler: (message) async => switch (message) {
        final InitMessage m => _replyPort = m.replyPort,
        final GetTokenMessage _ =>
          _replyPort.send(await _tokenService.getToken()),
        _ => null,
      },
    );
  }

  Future<void> dispose() async {
    await _gqlClient.dispose();
  }

  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
            OperationRequest<TData, TVars>)?
        forward,
  ]) =>
      _gqlClient.request(request, forward);

  Future<void> addRequest(OperationRequest<dynamic, dynamic> request) =>
      _gqlClient.addRequestToRequestController(request);

  Future<String> signIn({
    required String seed,
    String? prematureUserId,
  }) async {
    if (prematureUserId != null) _userId = prematureUserId;
    await _tokenService.setKeyPairFromSeed(seed);
    return _userId = await _tokenService.signIn();
  }

  Future<({String id, String seed})> signUp() async {
    final seed = await _tokenService.setNewKeyPair();
    _userId = await _tokenService.signUp();
    return (id: _userId, seed: seed);
  }

  Future<void> signOut() async {
    _userId = '';
    await _tokenService.signOut();
    await _gqlClient.clearCache();
  }

  Future<void> putAvatarImage(Uint8List image) async => _imageService.putAvatar(
        token: await _tokenService.getToken(),
        userId: userId,
        image: image,
      );

  Future<void> putBeaconImage(
    Uint8List image, {
    required String beaconId,
  }) async =>
      _imageService.putBeacon(
        token: await _tokenService.getToken(),
        beaconId: beaconId,
        userId: userId,
        image: image,
      );
}
