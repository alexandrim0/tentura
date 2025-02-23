import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';

import '../bloc/beacon_create_cubit.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        hintText: 'Beacon title (required)',
      ),
      keyboardType: TextInputType.text,
      maxLength: kTitleMaxLength,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onChanged: cubit.setTitle,
      validator: cubit.titleValidator,
    );
  }
}
