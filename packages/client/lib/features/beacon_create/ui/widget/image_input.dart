import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/ui/l10n/l10n.dart';

import '../bloc/beacon_create_cubit.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final _controller = TextEditingController();

  late final _l10n = L10n.of(context)!;

  late final _cubit = context.read<BeaconCreateCubit>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    readOnly: true,
    controller: _controller,
    decoration: InputDecoration(
      hintText: _l10n.attachImage,
      suffixIcon:
          BlocSelector<BeaconCreateCubit, BeaconCreateState, ImageEntity?>(
            selector: (state) => state.image,
            builder: (context, image) => image == null
                ? const Icon(Icons.add_a_photo_rounded)
                : IconButton(
                    icon: const Icon(Icons.cancel_rounded),
                    onPressed: () {
                      _controller.clear();
                      _cubit.clearImage();
                    },
                  ),
          ),
    ),
    onTap: _cubit.pickImage,
  );
}
