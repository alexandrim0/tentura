import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/data/repository/clipboard_repository.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import '../../data/repository/auth_remote_repository.dart';
import '../../data/repository/auth_local_repository.dart';
import '../entity/account_entity.dart';
import '../exception.dart';

@singleton
class AccountCase {
  AccountCase(
    this._authLocalRepository,
    this._authRemoteRepository,
    this._clipboardRepository,
    this._profileRemoteRepository,
  );

  final AuthLocalRepository _authLocalRepository;

  final AuthRemoteRepository _authRemoteRepository;

  final ClipboardRepository _clipboardRepository;

  final ProfileRepository _profileRemoteRepository;

  Stream<RepositoryEvent<Profile>> get profileChanges =>
      _profileRemoteRepository.changes;

  //
  //
  Future<String> getSeedFromClipboard() =>
      _clipboardRepository.getSeedFromClipboard();

  //
  //
  Future<String> getCodeFromClipboard() =>
      _clipboardRepository.getCodeFromClipboard(prefix: 'I');

  //
  //
  Future<String> getSeedByAccountId(String id) =>
      _authLocalRepository.getSeedByAccountId(id);

  ///
  /// A stream that emits the current account ID whenever it changes.
  /// It immediately emits the last known account ID upon subscription.
  ///
  Stream<String> currentAccountChanges() =>
      _authLocalRepository.currentAccountChanges();

  ///
  /// Returns the ID of the currently signed-in account.
  ///
  Future<String> getCurrentAccountId() =>
      _authLocalRepository.getCurrentAccountId();

  ///
  /// Returns a list of all locally stored user profiles.
  ///
  Future<List<AccountEntity>> getAccountsAll() =>
      _authLocalRepository.getAccountsAll();

  ///
  /// Retrieves a user profile by its [id].
  /// Returns `null` if no account with the given [id] is found.
  ///
  Future<AccountEntity?> getAccountById(String id) =>
      _authLocalRepository.getAccountById(id);

  ///
  /// Add account to local storage and signs in
  ///
  // TBD: add gql node to get profile data by auth request JWT
  //      to prevent signIn\signOut flow?
  Future<AccountEntity> addAccount(String seed) async {
    if (seed.isEmpty) {
      throw const AuthSeedIsWrongException();
    }
    final seedNormalized = base64UrlEncode(base64Decode(_base64Padded(seed)));
    await _authRemoteRepository.signIn(seedNormalized);

    final userId = await _authRemoteRepository.signIn(seedNormalized);
    await _authLocalRepository.addAccount(
      userId,
      seedNormalized,
    );

    final profile = await _profileRemoteRepository.fetchById(userId);
    await _authRemoteRepository.signOut();

    return fromProfile(profile);
  }

  ///
  /// Removes an account from local storage, keeps it on remote server
  ///
  Future<void> removeAccount(String id) =>
      _authLocalRepository.removeAccount(id);

  ///
  /// Updates the profile information for an existing [account].
  ///
  Future<void> updateAccount(AccountEntity account) =>
      _authLocalRepository.updateAccount(account);

  //
  //
  static Profile fromAccountEntity(AccountEntity account) => Profile(
    id: account.id,
    title: account.title,
    image: account.image,
  );

  //
  //
  static AccountEntity fromProfile(Profile profile) => AccountEntity(
    id: profile.id,
    title: profile.title,
    image: profile.image,
  );

  //
  //
  static String _base64Padded(String value) => switch (value.length % 4) {
    2 => '$value==',
    3 => '$value=',
    _ => value,
  };
}
