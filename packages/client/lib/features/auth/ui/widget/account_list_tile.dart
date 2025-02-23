import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/dialog/show_seed_dialog.dart';
import 'package:tentura/ui/dialog/share_code_dialog.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';

import '../bloc/auth_cubit.dart';
import '../dialog/account_remove_dialog.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({required this.account, super.key});

  final Profile account;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: AvatarRated.small(profile: account, withRating: false),
    title: Text(account.title),
    trailing: PopupMenuButton(
      itemBuilder:
          (context) => <PopupMenuEntry<void>>[
            //
            // Share account code
            PopupMenuItem<void>(
              child: const Text('Share account'),
              onTap:
                  () => ShareCodeDialog.show(
                    context,
                    header: account.id,
                    link: Uri.parse(kServerName).replace(
                      path: kPathAppLinkView,
                      queryParameters: {'id': account.id},
                    ),
                  ),
            ),
            const PopupMenuDivider(),

            // Share account seed
            PopupMenuItem<void>(
              child: const Text('Show seed'),
              onTap: () async {
                final seed = await GetIt.I<AuthCubit>().getSeedByAccountId(
                  account.id,
                );
                if (context.mounted) {
                  await ShowSeedDialog.show(
                    context,
                    seed: seed,
                    accountId: account.id,
                  );
                }
              },
            ),
            const PopupMenuDivider(),

            // Remove account
            PopupMenuItem<void>(
              child: const Text('Remove from list'),
              onTap: () => AccountRemoveDialog.show(context, id: account.id),
            ),
          ],
    ),

    // Log in
    onTap: () => GetIt.I<AuthCubit>().signIn(account.id),
  );
}
