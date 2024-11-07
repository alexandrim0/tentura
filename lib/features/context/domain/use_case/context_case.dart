import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/domain/entity/repository_event.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/context_repository.dart';
import '../entity/context_entity.dart';

@lazySingleton
class ContextCase {
  ContextCase({
    required AuthRepository authRepository,
    required ContextRepository contextRepository,
  })  : _authRepository = authRepository,
        _contextRepository = contextRepository;

  final AuthRepository _authRepository;
  final ContextRepository _contextRepository;

  Stream<String> get currentAccountChanges =>
      _authRepository.currentAccountChanges();

  Stream<RepositoryEvent<ContextEntity>> get contextChanges =>
      _contextRepository.changes;

  Future<Iterable<String>> fetch({bool fromCache = true}) =>
      _contextRepository.fetch(fromCache: fromCache);

  Future<void> add(String contextName) async =>
      _contextRepository.add(contextName);

  Future<void> delete(String contextName) async => _contextRepository.delete(
        userId: await _authRepository.getCurrentAccountId(),
        contextName: contextName,
      );
}
