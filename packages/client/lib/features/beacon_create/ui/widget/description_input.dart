import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';

import '../bloc/beacon_create_cubit.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Description',
      ),
      keyboardType: TextInputType.multiline,
      maxLength: kDescriptionLength,
      maxLines: null,
      onChanged: cubit.setDescription,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
