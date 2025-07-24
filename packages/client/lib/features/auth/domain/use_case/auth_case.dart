import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/data/repository/clipboard_repository.dart';

import 'package:tentura/features/profile/data/repository/profile_repository.dart';

import '../../data/repository/auth_remote_repository.dart';
import '../../data/repository/auth_repository.dart';
import '../exception.dart';

@singleton
class AuthCase {
  AuthCase(
    this._authRepository,
    this._authRemoteRepository,
    this._clipboardRepository,
    this._profileRepository,
  );

  final AuthRepository _authRepository;

  // ignore: unused_field // TBD:
  final AuthRemoteRepository _authRemoteRepository;

  final ClipboardRepository _clipboardRepository;

  final ProfileRepository _profileRepository;

  //
  Future<String> getSeedFromClipboard() =>
      _clipboardRepository.getSeedFromClipboard();

  //
  Future<String> getCodeFromClipboard() =>
      _clipboardRepository.getCodeFromClipboard(prefix: 'I');

  //
  Stream<RepositoryEvent<Profile>> get profileChanges =>
      _profileRepository.changes;

  ///
  ///
  Future<String> getSeedByAccountId(String id) =>
      _authRepository.getSeedByAccountId(id);

  /// A stream that emits the current account ID whenever it changes.
  ///
  /// It immediately emits the last known account ID upon subscription.
  Stream<String> currentAccountChanges() =>
      _authRepository.currentAccountChanges();

  /// Returns the ID of the currently signed-in account.
  Future<String> getCurrentAccountId() => _authRepository.getCurrentAccountId();

  /// Returns a list of all locally stored user profiles.
  Future<List<Profile>> getAccountsAll() => _authRepository.getAccountsAll();

  /// Retrieves a user profile by its [id].
  ///
  /// Returns `null` if no account with the given [id] is found.
  Future<Profile?> getAccountById(String id) =>
      _authRepository.getAccountById(id);

  ///
  ///
  Future<Profile> addAccount(String seed) async =>
      _profileRepository.fetchById(await _authRepository.addAccount(seed));

  /// Signs up a new user.
  ///
  /// Requires a [title] for the profile and an [invitationCode].
  /// Returns the ID of the newly created and signed-in account.
  Future<String> signUp({
    required String title,
    required String invitationCode,
  }) => _authRepository.signUp(
    title: title,
    invitationCode: invitationCode,
  );

  /// Signs in with the account corresponding to the given [id].
  ///
  /// Throws [AuthSeedIsWrongException] if the seed for the account is not found.
  Future<void> signIn(String id) => _authRepository.signIn(id);

  /// Signs out the current user.
  Future<void> signOut() => _authRepository.signOut();

  /// Removes an account from local storage.
  ///
  /// This also signs out the user if the removed account was the current one.
  Future<void> removeAccount(String id) => _authRepository.removeAccount(id);

  /// Updates the profile information for an existing [account].
  Future<void> updateAccount(Profile account) =>
      _authRepository.updateAccount(account);
}
