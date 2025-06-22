import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura/features/geo/ui/dialog/choose_location_dialog.dart';

import '../bloc/beacon_create_cubit.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
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
      hintText: _l10n.addLocation,
      suffixIcon:
          BlocSelector<BeaconCreateCubit, BeaconCreateState, Coordinates?>(
            bloc: _cubit,
            selector: (state) => state.coordinates,
            builder: (context, coordinates) => coordinates == null
                ? const Icon(TenturaIcons.location)
                : IconButton(
                    icon: const Icon(Icons.cancel_rounded),
                    onPressed: () {
                      _controller.clear();
                      _cubit.setLocation(null);
                    },
                  ),
          ),
    ),
    onTap: () async {
      final location = await ChooseLocationDialog.show(
        context,
        center: _cubit.state.coordinates,
      );
      if (location == null) return;
      _controller.text =
          location.place?.toString() ?? location.coords.toString();
      _cubit.setLocation(location.coords);
    },
  );
}
