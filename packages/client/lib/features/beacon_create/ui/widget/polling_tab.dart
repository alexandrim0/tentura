import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_create_cubit.dart';

class PollingTab extends StatefulWidget {
  const PollingTab({super.key});

  @override
  State<PollingTab> createState() => _PollingTabState();
}

class _PollingTabState extends State<PollingTab> {
  final _keyVariants = <Key>[
    UniqueKey(),
  ];

  late final _l10n = L10n.of(context)!;
  late final _theme = Theme.of(context);
  late final _beaconCreateCubit = context.read<BeaconCreateCubit>();

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      // Poll Question
      TextFormField(
        decoration: InputDecoration(
          labelText: _l10n.pollQuestionFieldLabel,
        ),
        keyboardType: TextInputType.text,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        onChanged: _beaconCreateCubit.setQuestion,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          } else if (value.length < kQuestionMinLength) {
            return _l10n.createBeaconErrorTooShortQuestion;
          } else {
            return null;
          }
        },
      ),

      // Label for Variants
      Padding(
        padding: kPaddingT,
        child: Text(
          _l10n.pollOptionsLabel,
          style: _theme.textTheme.bodyLarge,
        ),
      ),

      // Variants
      BlocSelector<BeaconCreateCubit, BeaconCreateState, int>(
        bloc: _beaconCreateCubit,
        selector: (state) => state.variants.length,
        builder: (context, index) => Column(
          children: [
            for (var i = 0; i < index; i++)
              TextFormField(
                key: _keyVariants[i],
                decoration: InputDecoration(
                  labelText: _l10n.optionLabel(i + 1),
                  suffix: IconButton(
                    color: Colors.red,
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      _beaconCreateCubit.removeVariant(i);
                      _keyVariants.removeAt(i);
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onChanged: (value) => _beaconCreateCubit.setVariant(i, value),
              ),
          ],
        ),
      ),

      // Add Variant
      Padding(
        padding: kPaddingLargeV,
        child: FilledButton.tonalIcon(
          icon: const Icon(Icons.add),
          label: Text(_l10n.addOptionButton),
          onPressed: () {
            _keyVariants.add(UniqueKey());
            _beaconCreateCubit.addVariant();
          },
        ),
      ),
    ],
  );
}
