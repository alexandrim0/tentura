import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/beacon_create_cubit.dart';

class DateRangeInput extends StatefulWidget {
  const DateRangeInput({super.key});

  @override
  State<DateRangeInput> createState() => _DateRangeInputState();
}

class _DateRangeInputState extends State<DateRangeInput> {
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
        _controller.text =
            '${dateFormatYMD(dateRange.start)} '
            '- ${dateFormatYMD(dateRange.end)}';
        _cubit.setDateRange(startAt: dateRange.start, endAt: dateRange.end);
      }
    },
  );
}
