import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/beacon_create_cubit.dart';

class DateRangeInput extends StatelessWidget {
  const DateRangeInput({
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
        hintText: AppLocalizations.of(context)!.setDisplayPeriod,
        suffixIcon:
            BlocSelector<BeaconCreateCubit, BeaconCreateState, DateTimeRange?>(
          selector: (state) => state.dateRange,
          builder: (context, dateRange) => dateRange == null
              ? const Icon(
                  TenturaIcons.calendar,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.cancel_rounded,
                  ),
                  onPressed: () {
                    controller.clear();
                    cubit.setDateRange(null);
                  },
                ),
        ),
      ),
      onTap: () async {
        final now = DateTime.timestamp();
        final dateRange = await showDateRangePicker(
          context: context,
          firstDate: now,
          currentDate: now,
          lastDate: now.add(const Duration(days: 365)),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          saveText: AppLocalizations.of(context)!.buttonOk,
        );
        if (dateRange != null) {
          controller.text = '${dateFormatYMD(dateRange.start)} '
              '- ${dateFormatYMD(dateRange.end)}';
          cubit.setDateRange(dateRange);
        }
      },
    );
  }
}
