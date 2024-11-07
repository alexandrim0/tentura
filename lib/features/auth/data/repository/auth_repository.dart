import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/data/service/local_secure_storage.dart';

import '../../domain/entity/account.dart';
import '../model/account_model.dart';

@singleton
class AuthRepository {
  static const _repositoryKey = 'Auth:';
  static const _accountKey = '${_repositoryKey}Id:';
  static const _accountIdAllKey = '${_repositoryKey}All:';
  static const _currentAccountKey = '${_repositoryKey}currentAccountId';

  AuthRepository(this._localStorage);

  final LocalSecureStorage _localStorage;

  final _controller = StreamController<String>.broadcast();

  String? _currentAccountId;

  @disposeMethod
  Future<void> dispose() => _controller.close();

  Stream<String> currentAccountChanges() async* {
    yield await getCurrentAccountId();
    yield* _controller.stream;
  }

  Future<String> getCurrentAccountId() => _currentAccountId == null
      ? _localStorage
          .read(_currentAccountKey)
          .then((v) => (_currentAccountId = v) ?? '')
      : SynchronousFuture(_currentAccountId ?? '');

  Future<String?> setCurrentAccountId(String? id) async {
    await _localStorage.write(_currentAccountKey, _currentAccountId = id);
    _controller.add(_currentAccountId ?? '');
    return _currentAccountId;
  }

  Future<Account?> getAccountById(String id) => _localStorage
      .read('$_accountKey$id')
      .then((v) => switch (jsonDecode(v ?? 'null')) {
            final Map<String, dynamic> j => AccountModel.fromJson(j).toEntity,
            _ => null,
          });

  Future<Set<Account>> getAccountAll() async {
    final result = <Account>{};
    for (final id in await _getIdAll()) {
      final account = await getAccountById(id);
      if (account != null) result.add(account);
    }
    return result;
  }

  Future<Account> putAccount(Account account) async {
    await _setIdAll((await _getIdAll())..add(account.id));
    await _localStorage.write(
      '$_accountKey${account.id}',
      jsonEncode(AccountModel.fromEntity(account).toJson()),
    );
    return account;
  }

  Future<void> removeAccountById(String id) async {
    await _setIdAll((await _getIdAll())..removeWhere((e) => e == id));
    await _localStorage.write('$_accountKey$id', null);
  }

  Future<Set<String>> _getIdAll() => _localStorage.read(_accountIdAllKey).then(
        (v) => (jsonDecode(v ?? '[]') as List).map((e) => e as String).toSet(),
      );

  Future<void> _setIdAll(Set<String> idAll) => _localStorage.write(
        _accountIdAllKey,
        jsonEncode(idAll.toList()),
      );
}
