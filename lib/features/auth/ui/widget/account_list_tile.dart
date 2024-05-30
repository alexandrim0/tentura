import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/routes.dart';
import 'package:tentura/ui/widget/avatar_image.dart';
import 'package:tentura/ui/dialog/share_code_dialog.dart';

import 'package:tentura/features/auth/ui/dialog/show_seed_dialog.dart';

import '../bloc/auth_cubit.dart';
import '../dialog/account_remove_dialog.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AvatarImage(size: 40, userId: id),
      title: Text(id),
      trailing: PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry<void>>[
          // Share account code
          PopupMenuItem<void>(
            child: const Text('Share account'),
            onTap: () => ShareCodeDialog.show(
              context,
              header: id,
              link: Uri.https(
                appLinkBase,
                pathProfileView,
                {'id': id},
              ),
            ),
          ),
          const PopupMenuDivider(),

          // Share account seed
          PopupMenuItem<void>(
            child: const Text('Show seed'),
            onTap: () => ShowSeedDialog.show(context, userId: id),
          ),
          const PopupMenuDivider(),

          // Remove account
          PopupMenuItem<void>(
            child: const Text('Remove from list'),
            onTap: () => AccountRemoveDialog.show(context, id: id).then(
              (v) {
                if (v ?? false) context.read<AuthCubit>().removeAccount(id);
              },
            ),
          ),
        ],
      ),

      // Log in
      onTap: () async {
        await context.read<AuthCubit>().signIn(id);
        if (context.mounted) context.go(pathHomeProfile);
      },
    );
  }
}
