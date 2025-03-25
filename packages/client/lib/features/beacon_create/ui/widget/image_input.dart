import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura_root/i10n/I10n.dart';

import '../bloc/beacon_create_cubit.dart';

class ImageInput extends StatelessWidget {
  const ImageInput({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: I10n.of(context)!.attachImage,
        suffixIcon:
            BlocSelector<BeaconCreateCubit, BeaconCreateState, ImageEntity?>(
          selector: (state) => state.image,
          builder: (context, image) => image == null
              ? const Icon(
                  Icons.add_a_photo_rounded,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.cancel_rounded,
                  ),
                  onPressed: () {
                    controller.clear();
                    cubit.clearImage();
                  },
                ),
        ),
      ),
      onTap: cubit.pickImage,
    );
  }
}
