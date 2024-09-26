import 'dart:async';
import 'dart:typed_data';
import 'package:ferry/ferry.dart';

import 'client/message.dart';
import 'service/image_service.dart';
import 'service/token_service_native.dart'
    if (dart.library.js_interop) 'service/token_service_web.dart';

abstract class TenturaApiBase {
  TenturaApiBase({
    required this.serverName,
    this.jwtExpiresIn = const Duration(minutes: 1),
    this.userAgent = 'Tentura client',
    this.storagePath = '',
  })  : _imageService = ImageService(serverName: serverName),
        _tokenService = TokenService(
          serverName: serverName,
          jwtExpiresIn: jwtExpiresIn,
        );

  final String userAgent;
  final String serverName;
  final String storagePath;
  final Duration jwtExpiresIn;

  final TokenService _tokenService;
  final ImageService _imageService;

  String _userId = '';

  Future<void> init();

  Future<void> close();

  Future<GetTokenResponse> getToken() => _tokenService.getToken();

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
  }

  Future<void> putAvatarImage(Uint8List image) async => _imageService.putAvatar(
        token: (await _tokenService.getToken()).valueOrException,
        userId: _userId,
        image: image,
      );

  Future<void> putBeaconImage(
    Uint8List image, {
    required String beaconId,
  }) async =>
      _imageService.putBeacon(
        token: (await _tokenService.getToken()).valueOrException,
        beaconId: beaconId,
        userId: _userId,
        image: image,
      );

  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
            OperationRequest<TData, TVars>)?
        forward,
  ]);

  Future<void> addRequestToRequestController<TData, TVars>(
    OperationRequest<TData, TVars> request,
  );
}
