import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/data/repository/clipboard_repository.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import '../../data/repository/auth_remote_repository.dart';
import '../../data/repository/auth_local_repository.dart';
import '../exception.dart';

@singleton
class AccountCase {
  AccountCase(
    this._authLocalRepository,
    this._authRemoteRepository,
    this._clipboardRepository,
    this._profileRepository,
  );

  final AuthLocalRepository _authLocalRepository;

  final AuthRemoteRepository _authRemoteRepository;

  final ClipboardRepository _clipboardRepository;

  final ProfileRepository _profileRepository;

  Stream<RepositoryEvent<Profile>> get profileChanges =>
      _profileRepository.changes;

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
  Future<List<Profile>> getAccountsAll() =>
      _authLocalRepository.getAccountsAll();

  ///
  /// Retrieves a user profile by its [id].
  /// Returns `null` if no account with the given [id] is found.
  ///
  Future<Profile?> getAccountById(String id) =>
      _authLocalRepository.getAccountById(id);

  ///
  /// Add account to local storage and signs in
  ///
  Future<Profile> addAccount(String seed) async {
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

    return _profileRepository.fetchById(userId);
  }

  ///
  /// Removes an account from local storage, keeps it on remote server
  ///
  Future<void> removeAccount(String id) =>
      _authLocalRepository.removeAccount(id);

  ///
  /// Updates the profile information for an existing [account].
  ///
  Future<void> updateAccount(Profile account) =>
      _authLocalRepository.updateAccount(account);

  //
  //
  static String _base64Padded(String value) => switch (value.length % 4) {
    2 => '$value==',
    3 => '$value=',
    _ => value,
  };
}
