import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/beacon_create_cubit.dart';

class DateRangeInput extends StatelessWidget {
  const DateRangeInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final cubit = context.read<BeaconCreateCubit>();
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: l10n.setDisplayPeriod,
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
          saveText: l10n.buttonOk,
        );
        if (dateRange != null) {
          controller.text =
              '${dateFormatYMD(dateRange.start)} '
              '- ${dateFormatYMD(dateRange.end)}';
          cubit.setDateRange(startAt: dateRange.start, endAt: dateRange.end);
        }
      },
    );
  }
}
