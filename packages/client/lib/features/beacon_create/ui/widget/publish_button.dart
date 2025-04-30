import 'package:flutter/material.dart';

import 'package:tentura_root/l10n/l10n.dart';

import 'package:tentura/features/context/ui/bloc/context_cubit.dart';

import '../bloc/beacon_create_cubit.dart';
import '../dialog/beacon_publish_dialog.dart';

class PublishButton extends StatelessWidget {
  const PublishButton({required this.formKey, super.key});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return BlocSelector<BeaconCreateCubit, BeaconCreateState, bool>(
      selector: (state) => state.isSuccess,
      builder:
          (context, isActive) => TextButton(
            onPressed:
                isActive
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
            child: Text(l10n.buttonPublish),
          ),
    );
  }
}
