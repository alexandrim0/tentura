import 'dart:async';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/auth/data/repository/auth_repository.dart';

import '../../data/context_repository.dart';

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

  Future<Iterable<String>> fetch() => _contextRepository.fetch();

  Future<String> add(String contextName) async {
    final context = await _contextRepository.add(contextName);
    if (context == null) {
      throw Exception('Could not add context [$contextName]');
    }
    return context;
  }

  Future<String> delete({
    required String userId,
    required String contextName,
  }) async {
    final context = await _contextRepository.delete(
      contextName: contextName,
      userId: userId,
    );
    if (context == null) {
      throw Exception('Could not delete context [$contextName]');
    }
    return context;
  }
}
