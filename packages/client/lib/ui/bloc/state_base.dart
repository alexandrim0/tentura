export 'package:flutter/foundation.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:freezed_annotation/freezed_annotation.dart';

abstract class StateBase {
  const StateBase({
    this.status = const StateIsSuccess(),
  });

  final StateStatus status;

  bool get isSuccess => status is StateIsSuccess;

  bool get isLoading => status is StateIsLoading;

  bool get hasError => status is StateHasError;

  bool get isNavigating => status is StateIsNavigating;
}

sealed class StateStatus {
  static const isSuccess = StateIsSuccess();

  static const isLoading = StateIsLoading();

  const StateStatus();
}

class StateIsSuccess extends StateStatus {
  const StateIsSuccess();
}

class StateIsLoading extends StateStatus {
  const StateIsLoading();
}

class StateIsMessaging extends StateStatus {
  const StateIsMessaging(this.message);

  final String? message;
}

class StateIsNavigating extends StateStatus {
  const StateIsNavigating(this.path);

  final String path;
}

class StateHasError extends StateStatus {
  const StateHasError(this.error);

  final Object error;
}
