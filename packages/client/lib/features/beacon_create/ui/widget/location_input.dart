import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura/features/geo/ui/dialog/choose_location_dialog.dart';

import '../bloc/beacon_create_cubit.dart';

class LocationInput extends StatelessWidget {
  const LocationInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: l10n.addLocation,
        suffixIcon:
            BlocSelector<BeaconCreateCubit, BeaconCreateState, Coordinates?>(
              selector: (state) => state.coordinates,
              builder:
                  (context, coordinates) =>
                      coordinates == null
                          ? const Icon(TenturaIcons.location)
                          : IconButton(
                            icon: const Icon(Icons.cancel_rounded),
                            onPressed: () {
                              controller.clear();
                              cubit.setLocation(null);
                            },
                          ),
            ),
      ),
      onTap: () async {
        final location = await ChooseLocationDialog.show(
          context,
          center: cubit.state.coordinates,
        );
        if (location == null) return;
        controller.text =
            location.place?.toString() ?? location.coords.toString();
        cubit.setLocation(location.coords);
      },
    );
  }
}
