import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tentura_root/i10n/I10n.dart';

import 'package:tentura/ui/dialog/qr_scan_dialog.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/auth_cubit.dart';
import '../dialog/account_add_dialog.dart';
import '../widget/account_list_tile.dart';

@RoutePage()
class AuthLoginScreen extends StatelessWidget implements AutoRouteWrapper {
  const AuthLoginScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocListener<AuthCubit, AuthState>(
        bloc: GetIt.I<AuthCubit>(),
        listener: commonScreenBlocListener,
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final authCubit = GetIt.I<AuthCubit>();
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      buildWhen: (_, c) => c.isSuccess,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(I10n.of(context)!.chooseAccount,),
          ),
          body: SafeArea(
            minimum: kPaddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state.accounts.isEmpty)
                  Padding(
                    padding: kPaddingAll,
                    child: Text(I10n.of(context)!.alreadyHaveAccount,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  // Accounts list
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.accounts.length,
                    itemBuilder: (_, i) {
                      final account = state.accounts[i];
                      return AccountListTile(
                        key: ValueKey(account),
                        account: account,
                      );
                    },
                    separatorBuilder: (_, _) => const Divider(),
                  ),

                // Recover from seed (QR)
                Padding(
                  padding: kPaddingAll,
                  child: OutlinedButton(
                    onPressed:
                        () async => authCubit.addAccount(
                          await QRScanDialog.show(context),
                        ),
                    child: Text(I10n.of(context)!.recoverFromQR),
                  ),
                ),

                // Recover from seed (clipboard)
                Padding(
                  padding: kPaddingH,
                  child: OutlinedButton(
                    onPressed: authCubit.getSeedFromClipboard,
                    child: Text(I10n.of(context)!.recoverFromClipboard),
                  ),
                ),
                const Spacer(),

                // Create new account
                Padding(
                  padding:
                      kPaddingAll +
                      const EdgeInsets.only(bottom: 60 - kSpacingMedium),
                  child: FilledButton(
                    onPressed: () => AccountAddDialog.show(context),
                    child: Text(I10n.of(context)!.createNewAccount),
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
