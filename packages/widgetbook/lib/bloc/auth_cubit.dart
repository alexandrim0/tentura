import 'package:injectable/injectable.dart';

import 'package:tentura/features/auth/domain/entity/account_entity.dart';
import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';

import '_data.dart';

@Singleton(as: AuthCubit)
class AuthCubitMock extends Cubit<AuthState> implements AuthCubit {
  AuthCubitMock()
    : super(
        AuthState(
          accounts: [
            AccountEntity(
              id: profileAlice.id,
              title: profileAlice.title,
              image: profileAlice.image,
            ),
          ],
          currentAccountId: profileAlice.id,
          updatedAt: DateTime.timestamp(),
        ),
      );

  @override
  Future<void> addAccount(String? seed) async {}

  @override
  bool checkIfIsMe(String id) => id == state.currentAccountId;

  @override
  bool checkIfIsNotMe(String id) => id != state.currentAccountId;

  @override
  Future<String> getSeedByAccountId(String id) async => 'seed';

  @override
  Future<void> getSeedFromClipboard() async {}

  @override
  Future<void> removeAccount(String id) async {}

  @override
  Future<void> signIn(String id) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUp({required String title, String? invitationCode}) async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<String> getCodeFromClipboard() {
    throw UnimplementedError();
  }
}
