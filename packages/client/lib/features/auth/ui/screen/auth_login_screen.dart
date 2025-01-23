import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/dialog/qr_scan_dialog.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/auth_cubit.dart';
import '../widget/account_list_tile.dart';

@RoutePage()
class AuthLoginScreen extends StatelessWidget implements AutoRouteWrapper {
  const AuthLoginScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocListener<AuthCubit, AuthState>(
        bloc: GetIt.I<AuthCubit>(),
        listener: commonScreenBlocListener,
      );

  @override
  Widget build(BuildContext context) {
    final authCubit = GetIt.I<AuthCubit>();
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      buildWhen: (p, c) => c.isSuccess,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Choose account'),
          ),
          body: SafeArea(
            minimum: kPaddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state.accounts.isEmpty)
                  const Padding(
                    padding: kPaddingAll,
                    child: Text(
                      'Already have an account?\n'
                      'Access it by scanning a QR code from another device\n'
                      'or by using your saved seed phrase.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  // Accounts list
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.accounts.length,
                    itemBuilder: (context, i) {
                      final account = state.accounts[i];
                      return AccountListTile(
                        key: ValueKey(account),
                        account: account,
                      );
                    },
                    separatorBuilder: (context, i) => const Divider(),
                  ),

                // Recover from seed (QR)
                Padding(
                  padding: kPaddingAll,
                  child: OutlinedButton(
                    onPressed: () async =>
                        authCubit.addAccount(await QRScanDialog.show(context)),
                    child: const Text('Recover from QR'),
                  ),
                ),

                // Recover from seed (clipboard)
                Padding(
                  padding: kPaddingH,
                  child: OutlinedButton(
                    onPressed: authCubit.getSeedFromClipboard,
                    child: const Text('Recover from clipboard'),
                  ),
                ),
                const Spacer(),

                // Create new account
                Padding(
                  padding: kPaddingAll +
                      const EdgeInsets.only(bottom: 60 - kSpacingMedium),
                  child: FilledButton(
                    onPressed: authCubit.signUp,
                    child: const Text('Create new'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
