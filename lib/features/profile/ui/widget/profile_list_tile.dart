import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/widget/avatar_image.dart';
import 'package:tentura/ui/dialog/share_code_dialog.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/auth/ui/dialog/show_seed_dialog.dart';
import 'package:tentura/features/auth/ui/dialog/account_remove_dialog.dart';

import '../bloc/profile_cubit.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ProfileCubit(id: userId),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: AvatarImage(
              userId: state.profile.imageId,
              size: 40,
            ),
            title: Text(state.profile.title),
            trailing: PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry<void>>[
                // Share account code
                PopupMenuItem<void>(
                  child: const Text('Share account'),
                  onTap: () => ShareCodeDialog.show(
                    context,
                    header: userId,
                    link: Uri.https(
                      kAppLinkBase,
                      pathAppLinkView,
                      {'id': userId},
                    ),
                  ),
                ),
                const PopupMenuDivider(),

                // Share account seed
                PopupMenuItem<void>(
                  child: const Text('Show seed'),
                  onTap: () => ShowSeedDialog.show(context, userId: userId),
                ),
                const PopupMenuDivider(),

                // Remove account
                PopupMenuItem<void>(
                  child: const Text('Remove from list'),
                  onTap: () => AccountRemoveDialog.show(context, id: userId),
                ),
              ],
            ),

            // Log in
            onTap: () => GetIt.I<AuthCubit>().signIn(userId),
          ),
        ),
      );
}
