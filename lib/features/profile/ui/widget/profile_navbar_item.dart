import 'package:flutter/material.dart';

import 'package:tentura/ui/widget/avatar_image.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';

import '../../domain/entity/profile.dart';
import '../bloc/profile_cubit.dart';

class ProfileNavBarItem extends StatelessWidget {
  const ProfileNavBarItem({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<ProfileCubit, ProfileState, Profile>(
        bloc: GetIt.I<ProfileCubit>(),
        selector: (state) => state.profile,
        builder: (context, profile) {
          final menuController = MenuController();
          final ids = GetIt.I<AuthCubit>()
              .state
              .accounts
              .where((e) => e.id != profile.id)
              .map((e) => e.id);
          return MenuAnchor(
            controller: menuController,
            menuChildren: [
              _ProfileMenuItem(
                isMe: true,
                profile: profile,
                key: Key('CurrentProfileMenuItem:${profile.imageId}'),
                onTap: menuController.close,
              ),
              for (final id in ids)
                BlocProvider(
                  create: (_) => ProfileCubit(id: id),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) => _ProfileMenuItem(
                      key: Key('ProfileMenuItem:${state.profile.imageId}'),
                      profile: state.profile,
                      onTap: () async {
                        menuController.close();
                        await GetIt.I<AuthCubit>().signIn(state.profile.id);
                      },
                    ),
                  ),
                ),
            ],
            child: GestureDetector(
              key: Key('ProfileNavbarItem:${profile.imageId}'),
              onLongPress: ids.length > 1 ? menuController.open : null,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AvatarImage(
                  userId: profile.imageId,
                  size: 36,
                ),
              ),
            ),
          );
        },
      );
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.profile,
    this.isMe = false,
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
              child: AvatarImage(
                userId: profile.imageId,
                size: 40,
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
