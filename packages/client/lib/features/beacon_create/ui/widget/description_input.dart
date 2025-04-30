import 'package:flutter/material.dart';

import 'package:tentura_root/l10n/l10n.dart';

import 'package:tentura/consts.dart';

import '../bloc/beacon_create_cubit.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(hintText: l10n.labelDescription),
      keyboardType: TextInputType.multiline,
      maxLength: kDescriptionMaxLength,
      maxLines: null,
      onChanged: cubit.setDescription,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      validator: cubit.descriptionValidator,
    );
  }
}
