import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/domain/entity/coordinates.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/string_input_validator.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import 'package:tentura/features/context/ui/widget/context_drop_down.dart';
import 'package:tentura/features/geo/ui/dialog/choose_location_dialog.dart';

import '../bloc/beacon_create_cubit.dart';

class InfoTab extends StatefulWidget {
  const InfoTab({super.key});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> with StringInputValidator {
  final _dateRangeController = TextEditingController();
  final _locationController = TextEditingController();

  late final _l10n = L10n.of(context)!;

  late final _cubit = context.read<BeaconCreateCubit>();

  @override
  void dispose() {
    _dateRangeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      // Title
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(hintText: _l10n.beaconTitleRequired),
        keyboardType: TextInputType.text,
        maxLength: kTitleMaxLength,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        onChanged: _cubit.setTitle,
        validator: (text) => titleValidator(_l10n, text),
      ),

      // Description
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(hintText: _l10n.labelDescription),
        keyboardType: TextInputType.multiline,
        maxLength: kDescriptionMaxLength,
        maxLines: null,
        onChanged: _cubit.setDescription,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        validator: (text) => descriptionValidator(_l10n, text),
      ),

      // Context
      const Padding(
        padding: kPaddingSmallV,
        child: ContextDropDown(
          key: Key('BeaconCreate.ContextDropDown'),
        ),
      ),

      // Location
      Padding(
        padding: kPaddingSmallV,
        child: TextFormField(
          readOnly: true,
          controller: _locationController,
          decoration: InputDecoration(
            hintText: _l10n.addLocation,
            suffixIcon:
                BlocSelector<
                  BeaconCreateCubit,
                  BeaconCreateState,
                  Coordinates?
                >(
                  bloc: _cubit,
                  selector: (state) => state.coordinates,
                  builder: (context, coordinates) => coordinates == null
                      ? const Icon(TenturaIcons.location)
                      : IconButton(
                          icon: const Icon(Icons.cancel_rounded),
                          onPressed: () {
                            _locationController.clear();
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
            _locationController.text =
                location.place?.toString() ?? location.coords.toString();
            _cubit.setLocation(location.coords);
          },
        ),
      ),

      // Date Range
      Padding(
        padding: kPaddingSmallV,
        child: TextFormField(
          readOnly: true,
          controller: _dateRangeController,
          decoration: InputDecoration(
            hintText: _l10n.setDisplayPeriod,
            suffixIcon: const Icon(TenturaIcons.calendar),
          ),
          onTap: () async {
            final now = DateTime.timestamp();
            final dateRange = await showDateRangePicker(
              context: context,
              firstDate: now,
              currentDate: now,
              lastDate: now.add(const Duration(days: 365)),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              saveText: _l10n.buttonOk,
            );
            if (dateRange != null) {
              _dateRangeController.text =
                  '${dateFormatYMD(dateRange.start)} '
                  '- ${dateFormatYMD(dateRange.end)}';
              _cubit.setDateRange(
                startAt: dateRange.start,
                endAt: dateRange.end,
              );
            }
          },
        ),
      ),
    ],
  );
}
