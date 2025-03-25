import 'package:flutter/material.dart';

import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura_root/i10n/I10n.dart';

import '../bloc/beacon_create_cubit.dart';
import '../dialog/beacon_publish_dialog.dart';

class PublishButton extends StatelessWidget {
  const PublishButton({
    required this.formKey,
    super.key,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) =>
      BlocSelector<BeaconCreateCubit, BeaconCreateState, bool>(
        selector: (state) => state.isSuccess,
        builder: (context, isActive) => TextButton(
          onPressed: isActive
              ? () async {
                  if (formKey.currentState?.validate() ?? false) {
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
                }
              : null,
          child: Text(I10n.of(context)!.buttonPublish),
        ),
      );
}
