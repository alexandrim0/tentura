import 'dart:math' show Random;
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:injectable/injectable.dart';

import 'package:tentura_root/utils/base64_padded.dart';

import 'package:tentura/data/database/database.dart';
import 'package:tentura/data/service/local_secure_storage.dart';
import 'package:tentura/data/service/remote_api_client/auth_link.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/profile.dart';

import '../../domain/exception.dart';
import '../gql/_g/sign_in.req.gql.dart';
import '../gql/_g/sign_up.req.gql.dart';

@singleton
class AuthRepository {
  AuthRepository(
    this._database,
    this._remoteApiService,
    this._localSecureStorage,
  );

  final Database _database;

  final RemoteApiService _remoteApiService;

  final LocalSecureStorage _localSecureStorage;

  final _controller = StreamController<String>.broadcast();

  String _currentAccountId = '';

  @disposeMethod
  Future<void> dispose() => _controller.close();

  Stream<String> currentAccountChanges() async* {
    yield _currentAccountId.isNotEmpty
        ? _currentAccountId
        : await getCurrentAccountId();

    yield* _controller.stream;
  }

  Future<String> getSeedByAccountId(String id) async =>
      await _localSecureStorage.read(_getAccountKey(id)) ?? '';

  Future<String> getCurrentAccountId() async =>
      _currentAccountId.isEmpty
          ? _localSecureStorage
              .read(_currentAccountKey)
              .then((v) => _currentAccountId = v ?? '')
          : _currentAccountId;

  Future<List<Profile>> getAccountsAll() async => [
    for (final account in await _database.managers.accounts.get())
      Profile(
        id: account.id,
        title: account.title,
        hasAvatar: account.hasAvatar,
      ),
  ];

  Future<Profile?> getAccountById(String id) => _database.managers.accounts
      .filter((f) => f.id.equals(id))
      .getSingleOrNull()
      .then(
        (e) =>
            e == null
                ? null
                : Profile(id: e.id, title: e.title, hasAvatar: e.hasAvatar),
      );

  Future<String> addAccount(String seed) async {
    if (seed.isEmpty) {
      throw const AuthSeedIsWrongException();
    }
    final seedNormalized = base64Padded(base64UrlEncode(base64Decode(seed)));
    final id = await _signIn(seedNormalized);
    await _addAccount(id, seedNormalized);

    return id;
  }

  /// Returns id of actual account
  Future<String> signUp({
    required String title,
    required String description,
  }) async {
    final seed = base64UrlEncode(
      Uint8List(32)..fillRange(0, 32, Random.secure().nextInt(256)),
    );
    _remoteApiService.setKeyPairFromSeed(seed);
    final response = await _remoteApiService
        .request(
          GSignUpReq(
            (r) =>
                r
                  ..context = const Context().withEntry(
                    const HttpAuthHeaders.noAuth(),
                  )
                  ..vars.title = title
                  ..vars.description = description
                  ..vars.authRequestToken = _remoteApiService.authRequestToken,
          ),
        )
        .firstWhere((e) => e.dataSource == DataSource.Link)
        .then((r) => r.dataOrThrow().signUp);

    if (response.subject.isEmpty) {
      throw const AuthIdIsWrongException();
    }
    _remoteApiService.authToken = (
      id: response.subject,
      accessToken: response.access_token,
      expiresAt: DateTime.timestamp().add(
        Duration(seconds: response.expires_in),
      ),
    );
    await _addAccount(response.subject, seed, title);
    await _setCurrentAccountId(response.subject);

    return response.subject;
  }

  Future<String> signIn(String id) async => _signIn(
    await _localSecureStorage.read(_getAccountKey(id)) ??
        (throw const AuthSeedIsWrongException()),
  );

  Future<void> signOut() async {
    _remoteApiService.setKeyPairFromSeed(null);
    await _setCurrentAccountId(null);
    // TBD: invalidate jwt on remote server also
  }

  /// Remove account only from local storage
  Future<void> removeAccount(String id) async {
    await signOut();

    await _database.managers.accounts.filter((e) => e.id.equals(id)).delete();

    await _localSecureStorage.delete(_getAccountKey(id));

    if (await getCurrentAccountId() == id) {
      await _setCurrentAccountId(null);
    }
  }

  Future<void> updateAccount(Profile account) => _database.managers.accounts
      .filter((f) => f.id.equals(account.id))
      .update(
        (o) =>
            o(title: Value(account.title), hasAvatar: Value(account.hasAvatar)),
      );

  Future<String> _signIn(String seed) async {
    _remoteApiService.setKeyPairFromSeed(seed);
    final response = await _remoteApiService
        .request(
          GSignInReq(
            (r) =>
                r
                  ..context = const Context().withEntry(
                    const HttpAuthHeaders.noAuth(),
                  )
                  ..vars.authRequestToken = _remoteApiService.authRequestToken,
          ),
        )
        .firstWhere((e) => e.dataSource == DataSource.Link)
        .then((r) => r.dataOrThrow().signIn);
    if (response.subject.isEmpty) {
      throw const AuthIdIsWrongException();
    }
    _remoteApiService.authToken = (
      id: response.subject,
      accessToken: response.access_token,
      expiresAt: DateTime.timestamp().add(
        Duration(seconds: response.expires_in),
      ),
    );
    await _setCurrentAccountId(response.subject);
    return response.subject;
  }

  Future<void> _setCurrentAccountId(String? id) async {
    await _localSecureStorage.write(
      _currentAccountKey,
      _currentAccountId = id ?? '',
    );
    _controller.add(_currentAccountId);
    log('Current User Id: $id');
  }

  Future<void> _addAccount(String id, String seed, [String? title]) async {
    await _localSecureStorage.write(_getAccountKey(id), seed);
    await _database.managers.accounts.create(
      (o) => title == null ? o(id: id) : o(id: id, title: Value(title)),
      mode: InsertMode.insert,
    );
  }

  static const _repositoryKey = 'Auth';

  static const _currentAccountKey = '$_repositoryKey:currentAccountId';

  static String _getAccountKey(String id) => '$_repositoryKey:Id:$id';
}
