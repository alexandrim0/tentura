import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/dialog/qr_scan_dialog.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/auth_cubit.dart';
import '../widget/account_list_tile.dart';

@RoutePage()
class AuthLoginScreen extends StatelessWidget implements AutoRouteWrapper {
  const AuthLoginScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocListener<ScreenCubit, ScreenState>(
        listener: commonScreenBlocListener,
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final authCubit = GetIt.I<AuthCubit>();
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      buildWhen: (_, c) => c.isSuccess,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(l10n.chooseAccount),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: BlocSelector<AuthCubit, AuthState, bool>(
                key: Key('Loader:${authCubit.hashCode}'),
                selector: (state) => state.isLoading,
                builder: LinearPiActive.builder,
                bloc: authCubit,
              ),
            ),
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
                    child: Text(
                      l10n.alreadyHaveAccount,
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
                    separatorBuilder: separatorBuilder,
                  ),

                // Recover from seed (QR)
                Padding(
                  padding: kPaddingAll,
                  child: OutlinedButton(
                    onPressed: () async => authCubit.addAccount(
                      await QRScanDialog.show(context),
                    ),
                    child: Text(l10n.recoverFromQR),
                  ),
                ),

                // Recover from seed (clipboard)
                Padding(
                  padding: kPaddingH,
                  child: OutlinedButton(
                    onPressed: authCubit.getSeedFromClipboard,
                    child: Text(l10n.recoverFromClipboard),
                  ),
                ),

                // Info for new users
                const Padding(
                  padding: kPaddingV,
                ),

                Padding(
                  padding: kPaddingH,
                  child: Text.rich(
                    TextSpan(
                      text: l10n.firstTimeHerePrefix,
                      children: [
                        TextSpan(
                          text: 'vadim@intersubjective.space',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final uri = Uri(
                                scheme: 'mailto',
                                path: 'vadim@intersubjective.space',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                        ),
                        TextSpan(
                          text: l10n.firstTimeHereSuffix,
                        ), // всё после контакта
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Create new account
                Padding(
                  padding:
                      kPaddingAll +
                      const EdgeInsets.only(bottom: 60 - kSpacingMedium),
                  child: FilledButton(
                    onPressed: context.read<ScreenCubit>().showProfileCreator,
                    child: Text(l10n.createNewAccount),
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
