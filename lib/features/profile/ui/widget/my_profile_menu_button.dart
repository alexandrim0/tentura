import 'package:tentura/ui/routes.dart';
import 'package:tentura/ui/utils/ferry_utils.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/auth/ui/dialog/show_seed_dialog.dart';

class MyProfileMenuButton extends StatelessWidget {
  const MyProfileMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          onTap: () => context.push(pathRating),
          child: const Text('View rating'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          child: const Text('Show seed'),
          onTap: () => ShowSeedDialog.show(
            context,
            userId: context.read<AuthCubit>().id,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          onTap: () => context.push(pathProfileEdit),
          child: const Text('Edit profile'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          onTap: () {},
          child: const Text('Settings'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          onTap: () async {
            await context.read<AuthCubit>().signOut();
            if (context.mounted) context.go(pathAuthLogin);
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}