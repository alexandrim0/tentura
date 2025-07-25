import 'dart:async';
import 'dart:developer';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/database/database.dart';
import 'package:tentura/data/service/local_secure_storage.dart';
import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/domain/entity/profile.dart';

import '../../domain/exception.dart';

@singleton
class AuthLocalRepository {
  AuthLocalRepository(
    this._database,
    this._localSecureStorage,
  );

  final Database _database;

  final LocalSecureStorage _localSecureStorage;

  final _controllerIdChanges = StreamController<String>.broadcast();

  String _currentAccountId = '';

  //
  //
  @disposeMethod
  Future<void> dispose() async {
    await _controllerIdChanges.close();
  }

  //
  //
  Stream<String> currentAccountChanges() async* {
    yield _currentAccountId.isNotEmpty
        ? _currentAccountId
        : await getCurrentAccountId();

    yield* _controllerIdChanges.stream;
  }

  //
  //
  Future<String> getSeedByAccountId(String id) async =>
      await _localSecureStorage.read(_getAccountKey(id)) ??
      (throw const AuthIdNotFoundException());

  //
  //
  Future<String> getCurrentAccountId() async => _currentAccountId.isEmpty
      ? _localSecureStorage
            .read(_currentAccountKey)
            .then((v) => _currentAccountId = v ?? '')
      : _currentAccountId;

  //
  //
  Future<List<Profile>> getAccountsAll() async => [
    for (final account in await _database.managers.accounts.get())
      Profile(
        id: account.id,
        title: account.title,
        image: account.hasAvatar
            ? ImageEntity(
                id: account.imageId,
                blurHash: account.blurHash,
                height: account.height,
                width: account.width,
              )
            : null,
      ),
  ];

  //
  //
  Future<Profile?> getAccountById(String id) => _database.managers.accounts
      .filter((f) => f.id.equals(id))
      .getSingleOrNull()
      .then(
        (e) => e == null
            ? null
            : Profile(
                id: e.id,
                title: e.title,
                image: e.hasAvatar
                    ? ImageEntity(
                        id: e.imageId,
                        blurHash: e.blurHash,
                        height: e.height,
                        width: e.width,
                      )
                    : null,
              ),
      );

  ///
  /// Returns id of actual account
  ///
  // Future<String> signUp({
  //   required String title,
  //   required String invitationCode,
  // }) async {
  // final seed = base64UrlEncode(
  //   Uint8List.fromList(List<int>.generate(32, (_) => _random.nextInt(256))),
  // );
  // final authRequestToken = await _remoteApiService.setAuth(
  //   seed: seed,
  //   authTokenFetcher: authTokenFetcher,
  //   returnAuthRequestToken: AuthRequestIntentSignUp(
  //     invitationCode: invitationCode,
  //   ),
  // );
  // final request = GSignUpReq((b) {
  //   b.context = const Context().withEntry(const HttpAuthHeaders.noAuth());
  //   b.vars
  //     ..title = title
  //     ..authRequestToken = authRequestToken;
  // });
  // final response = await _remoteApiService
  //     .request(request)
  //     .firstWhere((e) => e.dataSource == DataSource.Link)
  //     .then((r) => r.dataOrThrow().signUp);
  // await addAccount(response.subject, seed, title);

  // await _remoteApiService.setAuth(
  //   seed: seed,
  //   authTokenFetcher: authTokenFetcher,
  // );

  //   final credentials = await _remoteApiService.getAuthToken();
  //   await setCurrentAccountId(credentials.userId);

  //   return credentials.userId;
  // }

  ///
  /// Remove account only from local storage
  ///
  Future<void> removeAccount(String id) async {
    await _database.managers.accounts.filter((e) => e.id.equals(id)).delete();
    await _localSecureStorage.delete(_getAccountKey(id));
  }

  //
  //
  Future<void> updateAccount(Profile account) => _database.managers.accounts
      .filter((f) => f.id.equals(account.id))
      .update(
        (o) => o(
          title: Value(account.title),
          hasAvatar: Value(account.hasAvatar),
        ),
      );

  //
  //
  Future<void> setCurrentAccountId(String? id) async {
    await _localSecureStorage.write(
      _currentAccountKey,
      _currentAccountId = id ?? '',
    );
    _controllerIdChanges.add(_currentAccountId);
    log('Current User Id: $id');
  }

  //
  //
  Future<void> addAccount(String id, String seed, [String? title]) async {
    await _localSecureStorage.write(_getAccountKey(id), seed);
    await _database.managers.accounts.create(
      (o) => title == null ? o(id: id) : o(id: id, title: Value(title)),
      mode: InsertMode.insert,
    );
  }

  static const _repositoryKey = 'Auth';

  static const _currentAccountKey = '$_repositoryKey:currentAccountId';

  //
  static String _getAccountKey(String id) => '$_repositoryKey:Id:$id';
}
