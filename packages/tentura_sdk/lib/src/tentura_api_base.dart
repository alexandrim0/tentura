import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:ferry/ferry.dart' show OperationRequest, OperationResponse;

import 'consts.dart';
import 'client/message.dart';
import 'service/token_service_native.dart'
    if (dart.library.js_interop) 'service/token_service_web.dart';

abstract class TenturaApiBase {
  TenturaApiBase({
    this.apiUrlBase = kServerName,
    this.jwtExpiresIn = const Duration(minutes: 1),
    this.userAgent = kUserAgent,
    this.storagePath = '',
    this.isDebugMode = false,
  }) : _tokenService = TokenService(
          apiUrlBase: apiUrlBase,
          jwtExpiresIn: jwtExpiresIn,
        );

  final String apiUrlBase;
  final String userAgent;
  final String storagePath;
  final Duration jwtExpiresIn;
  final bool isDebugMode;

  final TokenService _tokenService;

  late final _uploadUrl = Uri.parse(apiUrlBase + kPathImageUpload);

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

  Future<void> uploadImage({
    required Uint8List image,
    required String id,
  }) async =>
      put(
        _uploadUrl.replace(query: 'id=$id'),
        headers: {
          kHeaderContentType: kContentTypeJpeg,
          kHeaderAuthorization:
              'Bearer ${(await _tokenService.getToken()).valueOrException}',
        },
        body: image,
      );

  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    Stream<OperationResponse<TData, TVars>> Function(
            OperationRequest<TData, TVars>)?
        forward,
  ]);
}
