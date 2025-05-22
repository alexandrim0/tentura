import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/utils/string_input_validator.dart';

import '../bloc/beacon_create_cubit.dart';

class TitleInput extends StatelessWidget with StringInputValidator {
  const TitleInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(hintText: l10n.beaconTitleRequired),
      keyboardType: TextInputType.text,
      maxLength: kTitleMaxLength,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onChanged: cubit.setTitle,
      validator: (text) => titleValidator(l10n, text),
    );
  }
}
