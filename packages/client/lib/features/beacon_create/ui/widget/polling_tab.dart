import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_create_cubit.dart';

class PollingTab extends StatelessWidget {
  const PollingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    final cubit = context.read<BeaconCreateCubit>();
    return ListView(
      children: [
        // Poll Question
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.pollQuestionFieldLabel,
          ),
          keyboardType: TextInputType.text,
          initialValue: cubit.state.question,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onChanged: cubit.setQuestion,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            } else if (value.length < kQuestionMinLength) {
              return l10n.createBeaconErrorTooShortQuestion;
            } else {
              return null;
            }
          },
        ),

        // Label for Variants
        Padding(
          padding: kPaddingT,
          child: Text(
            l10n.pollOptionsLabel,
            style: theme.textTheme.bodyLarge,
          ),
        ),

        // Variants
        BlocBuilder<BeaconCreateCubit, BeaconCreateState>(
          bloc: cubit,
          builder: (context, state) => Column(
            children: [
              for (var i = 0; i < state.variants.length; i++)
                TextFormField(
                  key: state.variantsKeys[i],
                  decoration: InputDecoration(
                    labelText: l10n.optionLabel(i + 1),
                    suffix: IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => cubit.removeVariant(i),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  initialValue: state.variants[i],
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onChanged: (value) => cubit.setVariant(i, value),
                ),
            ],
          ),
        ),

        // Add Variant
        Padding(
          padding: kPaddingLargeV,
          child: FilledButton.tonalIcon(
            icon: const Icon(Icons.add),
            label: Text(l10n.addOptionButton),
            onPressed: cubit.addVariant,
          ),
        ),
      ],
    );
  }
}
