import 'package:freezed_annotation/freezed_annotation.dart';

part 'credentials.freezed.dart';

@freezed
abstract class Credentials with _$Credentials {
  const factory Credentials({
    required String userId,
    required String accessToken,
    required DateTime expiresAt,
  }) = _Credentials;

  const Credentials._();

  bool get hasValidToken => DateTime.timestamp().isBefore(expiresAt);
}
