import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/widget/avatar_image.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';

class ProfileNavBarItem extends StatelessWidget {
  const ProfileNavBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = GetIt.I<AuthCubit>();
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        final menuController = MenuController();
        return MenuAnchor(
          controller: menuController,
          menuChildren: [
            for (final account in authCubit.state.accounts)
              _AccountMenuItem(
                key: ValueKey(account),
                isMe: account.id == state.currentAccountId,
                profile: account,
                onTap: () {
                  menuController.close();
                  authCubit.signIn(account.id);
                },
              ),
          ],
          child: GestureDetector(
            key: Key('ProfileNavbarItem:${state.currentAccount}'),
            onLongPress: state.accounts.length > 1 ? menuController.open : null,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AvatarImage(
                profile: state.currentAccount,
                size: 36,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.profile,
    required this.isMe,
    this.onTap,
    super.key,
  });

  final bool isMe;
  final Profile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: AvatarImage.small(
                profile: profile,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                profile.title,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isMe)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.check),
              ),
          ],
        ),
      );
}
