import 'dart:async';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/database/database.dart';
import 'package:tentura/data/service/local_secure_storage.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/profile.dart';

import '../../domain/exception.dart';

@singleton
class AuthRepository {
  AuthRepository(
    this._logger,
    this._database,
    this._remoteApiService,
    this._localSecureStorage,
  );

  final Logger _logger;

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

  Future<String> getCurrentAccountId() async => _currentAccountId.isEmpty
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
        (e) => e == null
            ? null
            : Profile(
                id: e.id,
                title: e.title,
                hasAvatar: e.hasAvatar,
              ),
      );

  Future<String> addAccount(String seed) async {
    if (seed.isEmpty) throw const AuthSeedIsWrongException();

    final id = await _remoteApiService.signIn(seed: seed);

    if (id.isEmpty) throw const AuthIdIsWrongException();

    await _addAccount(id, seed);

    return id;
  }

  Future<String> signUp() async {
    final (:id, :seed) = await _remoteApiService.signUp();

    if (id.isEmpty) throw const AuthIdIsWrongException();

    if (seed.isEmpty) throw const AuthSeedIsWrongException();

    await _addAccount(id, seed);

    await _setCurrentAccountId(id);

    return id;
  }

  Future<void> signIn(
    String id, {
    bool isPremature = false,
  }) async {
    await _remoteApiService.signIn(
      prematureUserId: isPremature ? id : null,
      seed: await _localSecureStorage.read(_getAccountKey(id)) ?? '',
    );
    await _setCurrentAccountId(id);
  }

  Future<void> signOut() async {
    await _remoteApiService.signOut();

    await _setCurrentAccountId(null);
  }

  /// Remove account only from local storage
  Future<void> removeAccount(String id) async {
    await _remoteApiService.signOut();

    await _database.managers.accounts.filter((e) => e.id.equals(id)).delete();

    await _localSecureStorage.delete(_getAccountKey(id));

    if (await getCurrentAccountId() == id) {
      await _setCurrentAccountId(null);
    }
  }

  Future<void> updateAccount(Profile account) => _database.managers.accounts
      .filter((f) => f.id.equals(account.id))
      .update((o) => o(
            title: Value(account.title),
            hasAvatar: Value(account.hasAvatar),
          ));

  Future<void> _setCurrentAccountId(String? id) async {
    await _localSecureStorage.write(
      _currentAccountKey,
      _currentAccountId = id ?? '',
    );
    _controller.add(_currentAccountId);
    _logger.i('Current User Id: $id');
  }

  Future<void> _addAccount(String id, String seed) async {
    await _localSecureStorage.write(
      _getAccountKey(id),
      seed,
    );
    await _database.managers.accounts.create(
      (o) => o(id: id),
      mode: InsertMode.insert,
    );
  }

  static const _repositoryKey = 'Auth';

  static const _currentAccountKey = '$_repositoryKey:currentAccountId';

  static String _getAccountKey(String id) => '$_repositoryKey:Id:$id';
}
