import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/dialog/qr_scan_dialog.dart';

import 'package:tentura/features/profile/ui/widget/profile_list_tile.dart';

import '../bloc/auth_cubit.dart';

class AuthLoginScreen extends StatelessWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (p, c) => c.hasError,
      listener: (context, state) {
        switch (state.error) {
          case SeedExistsException:
            showSnackBar(
              context,
              isError: true,
              text: 'Seed already exists',
            );

          case SeedIsWrongException:
            showSnackBar(
              context,
              isError: true,
              text: 'There is no correct seed!',
            );

          default:
            showSnackBar(
              context,
              isError: true,
              text: state.error?.toString() ?? 'Unknown error!',
            );
        }
      },
      buildWhen: (p, c) => c.hasNoError,
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();
        final accounts = state.accounts.keys.toList();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Choose account'),
          ),
          body: SafeArea(
            minimum: paddingMediumH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state.accounts.isEmpty)
                  const Padding(
                    padding: paddingMediumA,
                    child: Text(
                      'You can add your account by\n'
                      'scanning a QR from your other device\n'
                      'or using a saved seed.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  // Accounts list
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    itemBuilder: (context, i) => AccountListTile(
                      id: accounts[i],
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                  ),

                // Create from seed (QR)
                Padding(
                  padding: paddingMediumA,
                  child: OutlinedButton(
                    child: const Text('Add account by QR'),
                    onPressed: () async =>
                        authCubit.addAccount(await QRScanDialog.show(context)),
                  ),
                ),

                // Create from seed (clipboard)
                Padding(
                  padding: paddingMediumA,
                  child: OutlinedButton(
                    child: const Text('Add account by seed'),
                    onPressed: () async {
                      if (await Clipboard.hasStrings() && context.mounted) {
                        await authCubit.addAccount(
                            (await Clipboard.getData(Clipboard.kTextPlain))
                                ?.text);
                      }
                    },
                  ),
                ),
                const Spacer(),

                // Create new account
                Padding(
                  padding: paddingMediumA,
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
