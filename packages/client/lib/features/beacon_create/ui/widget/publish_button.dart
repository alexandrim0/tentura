import 'package:flutter/material.dart';

import 'package:tentura/features/context/ui/bloc/context_cubit.dart';

import '../bloc/beacon_create_cubit.dart';
import '../dialog/beacon_publish_dialog.dart';

class PublishButton extends StatelessWidget {
  const PublishButton({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<BeaconCreateCubit, BeaconCreateState, bool>(
        selector: (state) => state.isSuccess,
        builder: (context, isActive) => TextButton(
          onPressed: isActive
              ? () async {
                  final contextName =
                      context.read<ContextCubit>().state.selected;
                  if (await BeaconPublishDialog.show(context) ?? false) {
                    if (context.mounted) {
                      await context.read<BeaconCreateCubit>().publish(
                            context: contextName,
                          );
                    }
                  }
                }
              : null,
          child: const Text('Publish'),
        ),
      );
}
