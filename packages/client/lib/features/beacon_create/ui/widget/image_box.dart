import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/image_entity.dart';

import '../bloc/beacon_create_cubit.dart';

class ImageBox extends StatelessWidget {
  const ImageBox({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<BeaconCreateCubit, BeaconCreateState, ImageEntity?>(
        selector: (state) => state.image,
        builder: (context, image) => image == null
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
                image.imageBytes,
                key: ObjectKey(image),
                fit: BoxFit.fitWidth,
              ),
      );
}
