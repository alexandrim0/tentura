import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura_root/i10n/I10n.dart';

import '../bloc/beacon_create_cubit.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(hintText: I10n.of(context)!.labelDescription),
      keyboardType: TextInputType.multiline,
      maxLength: kDescriptionMaxLength,
      maxLines: null,
      onChanged: cubit.setDescription,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      validator: cubit.descriptionValidator,
    );
  }
}
