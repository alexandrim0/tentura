import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_cubit.dart';

class BeaconDeleteDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String id,
  }) =>
      showDialog(
        context: context,
        builder: (_) => BeaconDeleteDialog(id: id),
      );

  const BeaconDeleteDialog({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
        title: const Text(
          'Are you sure you want to delete this beacon?',
        ),
        actions: [
          // Delete
          TextButton(
            onPressed: () async {
              try {
                await GetIt.I<BeaconCubit>().delete(id);
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
            child: const Text('Delete'),
          ),

          // Cancel
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
        ],
      );
}
