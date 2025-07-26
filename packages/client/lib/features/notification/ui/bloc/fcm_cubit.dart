import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';

import 'package:tentura/features/settings/data/repository/settings_repository.dart';

import '../../data/repository/fcm_local_repository.dart';
import '../../data/repository/fcm_remote_repository.dart';
import 'fcm_state.dart';

@singleton
class FcmCubit extends Cubit<FcmState> {
  FcmCubit(
    this._fcmLocalRepository,
    this._fcmRemoteRepository,
    this._settingsRepository,
  ) : super(const FcmState()) {
    _tokenRefreshSubscription = _fcmLocalRepository.onTokenRefresh.listen(
      _registerFcmToken,
      cancelOnError: false,
    );
    init();
  }

  final FcmLocalRepository _fcmLocalRepository;

  final FcmRemoteRepository _fcmRemoteRepository;

  final SettingsRepository _settingsRepository;

  late final StreamSubscription<String> _tokenRefreshSubscription;

  //
  @override
  @disposeMethod
  Future<void> close() async {
    await _tokenRefreshSubscription.cancel();
    return super.close();
  }

  Future<void> init() async {
    emit(state.copyWith(status: StateStatus.isLoading));
    try {
      final fcmLastRegistrationAt = await _settingsRepository
          .getLastFcmRegistrationAt();

      if (fcmLastRegistrationAt == null ||
          fcmLastRegistrationAt.isBefore(
            DateTime.timestamp().add(const Duration(days: 30)),
          )) {
        final fcmToken = await _fcmLocalRepository.getToken();

        if (fcmToken != null) {
          await _registerFcmToken(fcmToken);
          await _settingsRepository.setLastFcmRegistrationAt(DateTime.now());
          emit(
            state.copyWith(
              permissions: await _fcmLocalRepository.requestPermission(),
              status: StateStatus.isSuccess,
            ),
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(status: StateHasError(e)));
    }
  }

  //
  Future<String> _getAppId() async {
    var appId = await _settingsRepository.getAppId();
    if (appId == null) {
      appId = const Uuid().v4();
      await _settingsRepository.setAppId(appId);
    }
    return appId;
  }

  //
  Future<void> _registerFcmToken(String token) async {
    final appId = await _getAppId();
    emit(
      state.copyWith(
        appId: appId,
        token: token,
        status: StateStatus.isSuccess,
      ),
    );
    await _fcmRemoteRepository.registerToken(
      appId: appId,
      token: token,
      platform: kIsWeb ? 'web' : 'android',
    );
  }
}
