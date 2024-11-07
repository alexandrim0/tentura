import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/dialog/qr_scan_dialog.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/profile/ui/widget/profile_list_tile.dart';

import '../../domain/exception.dart';
import '../bloc/auth_cubit.dart';

@RoutePage()
class AuthLoginScreen extends StatelessWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: GetIt.I<AuthCubit>(),
      listenWhen: (p, c) => c.hasError,
      listener: (context, state) {
        switch (state.error) {
          case AuthSeedExistsException:
            showSnackBar(
              context,
              isError: true,
              text: 'Seed already exists',
            );

          case AuthSeedIsWrongException:
            showSnackBar(
              context,
              isError: true,
              text: 'There is no correct seed!',
            );

          case AuthIdIsWrongException:
            showSnackBar(
              context,
              isError: true,
              text: 'Account ID is wrong!',
            );

          default:
            showSnackBarError(context, state);
        }
      },
      buildWhen: (p, c) => c.hasNoError,
      builder: (context, state) {
        final authCubit = GetIt.I<AuthCubit>();
        final accounts = state.accounts.map((e) => e.id).toList()..sort();
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
                    itemCount: accounts.length,
                    itemBuilder: (context, i) {
                      final account = accounts[i];
                      return AccountListTile(
                        key: ValueKey(account),
                        userId: account,
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
                    child: const Text('Recover by QR'),
                  ),
                ),

                // Recover from seed (clipboard)
                Padding(
                  padding: kPaddingH,
                  child: OutlinedButton(
                    child: const Text('Recover by seed'),
                    onPressed: () async {
                      if (await Clipboard.hasStrings() && context.mounted) {
                        await authCubit.addAccount(
                          (await Clipboard.getData(Clipboard.kTextPlain))?.text,
                        );
                      }
                    },
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
