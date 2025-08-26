import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/image_entity.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/beacon_create_cubit.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  final _controller = TextEditingController();

  late final _l10n = L10n.of(context)!;

  late final _cubit = context.read<BeaconCreateCubit>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      // Image Control
      Padding(
        padding: kPaddingSmallV,
        child: TextFormField(
          readOnly: true,
          controller: _controller,
          decoration: InputDecoration(
            hintText: _l10n.attachImage,
            suffixIcon:
                BlocSelector<
                  BeaconCreateCubit,
                  BeaconCreateState,
                  ImageEntity?
                >(
                  selector: (state) => state.image,
                  builder: (_, image) => image == null
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
        ),
      ),

      // Image Container
      Padding(
        padding: const EdgeInsets.all(kSpacingLarge * 2),
        child: BlocSelector<BeaconCreateCubit, BeaconCreateState, ImageEntity?>(
          selector: (state) => state.image,
          builder: (_, image) => image?.imageBytes == null
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: const Icon(
                    Icons.photo_outlined,
                    size: 256,
                  ),
                )
              : Image.memory(
                  image!.imageBytes!,
                  key: ObjectKey(image),
                  fit: BoxFit.fitWidth,
                ),
        ),
      ),
    ],
  );
}
