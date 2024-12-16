import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/friends_cubit.dart';

class FriendRemoveDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required Profile profile,
  }) =>
      showDialog(
        context: context,
        builder: (_) => FriendRemoveDialog(profile: profile),
      );

  const FriendRemoveDialog({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
        title: Text(
          'Are you sure you want to delete ${profile.title} from friends list?',
        ),
        actions: [
          // Remove
          TextButton(
            onPressed: () async {
              try {
                await GetIt.I<FriendsCubit>().removeFriend(profile);
              } catch (e) {
                if (context.mounted) {
                  showSnackBar(
                    context,
                    isError: true,
                    text: e.toString(),
                  );
                }
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),

          // Cancel
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
        ],
      );
}
