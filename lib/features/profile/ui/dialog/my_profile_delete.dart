import 'package:tentura/ui/routes.dart';
import 'package:tentura/ui/utils/ferry_utils.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';

import '../../data/gql/_g/user_delete_by_id.req.gql.dart';

class MyProfileDeleteDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        builder: (context) => const MyProfileDeleteDialog(),
      );

  const MyProfileDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text(
          'Are you sure you want to delete your profile?',
        ),
        content: const Text(
          'All your beacons and personal data will be deleted completely.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final authCubit = context.read<AuthCubit>();
              final myId = authCubit.state.currentAccount;
              final response = await doRequest(
                context: context,
                request: GUserDeleteByIdReq((b) => b.vars..id = myId),
              );
              if (response.hasErrors && context.mounted) {
                context.pop();
              } else {
                await authCubit.deleteAccount(myId);
                if (context.mounted) context.go(pathAuthLogin);
              }
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: context.pop,
            child: const Text('Cancel'),
          ),
        ],
      );
}
