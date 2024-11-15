import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/database/database.dart';
import 'package:tentura/data/service/local_secure_storage.dart';
import 'package:tentura/data/service/remote_api_service.dart';
import 'package:tentura/domain/entity/profile.dart';

import '../../domain/exception.dart';

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

  Future<String> getCurrentAccountId() => _currentAccountId.isEmpty
      ? _localSecureStorage
          .read(_currentAccountKey)
          .then((v) => _currentAccountId = v ?? '')
      : SynchronousFuture(_currentAccountId);

  Future<List<Profile>> getAccountsAll() async => [
        for (final account in await _database.accounts.all().get())
          Profile(
            id: account.id,
            title: account.title,
            hasAvatar: account.hasPicture,
          ),
      ];

  Future<Profile> addAccount(String seed) async {
    if (seed.isEmpty) throw const AuthSeedIsWrongException();

    final id = await _remoteApiService.signIn(seed: seed);

    if (id.isEmpty) throw const AuthIdIsWrongException();

    return _addAccount(id, seed);
  }

  Future<Profile> signUp() async {
    final (:id, :seed) = await _remoteApiService.signUp();

    if (id.isEmpty) throw const AuthIdIsWrongException();

    if (seed.isEmpty) throw const AuthSeedIsWrongException();

    return _addAccount(id, seed);
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

    await _database.accounts.deleteWhere((t) => t.id.equals(id));

    await _localSecureStorage.delete(_getAccountKey(id));

    if (await getCurrentAccountId() == id) {
      await _setCurrentAccountId(null);
    }
  }

  Future<void> updateAccount(Profile account) =>
      _database.accounts.replaceOne(Account(
        id: account.id,
        title: account.title,
        hasPicture: account.hasAvatar,
      ));

  Future<void> _setCurrentAccountId(String? id) async {
    await _localSecureStorage.write(
      _currentAccountKey,
      _currentAccountId = id ?? '',
    );
    _controller.add(_currentAccountId);
  }

  Future<Profile> _addAccount(String id, String seed) async {
    await _localSecureStorage.write(
      _getAccountKey(id),
      seed,
    );
    await _database.accounts.insertOne(Account(
      id: id,
      title: '',
      hasPicture: false,
    ));
    await _setCurrentAccountId(id);

    return Profile(id: id);
  }

  static const _repositoryKey = 'Auth';

  static const _currentAccountKey = '$_repositoryKey:currentAccountId';

  static String _getAccountKey(String id) => '$_repositoryKey:Id:$id';
}
