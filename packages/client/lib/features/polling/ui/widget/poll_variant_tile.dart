import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

class PollVariantTile extends StatelessWidget {
  const PollVariantTile({
    required this.row,
    required this.hasVoted,
    required this.isSelected,
    this.onTap,
    super.key,
  });

  final MockPollRow row;
  final bool hasVoted;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context)!;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: kSpacingSmall,
        ),
        child: Row(
          children: [
            // визуальный индикатор выбора
            SizedBox(
              width: 38,
              child: Padding(
                padding: const EdgeInsets.only(right: kSpacingMedium),
                child: hasVoted
                    ? Icon(
                        isSelected ? Icons.check_circle : Icons.circle,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      )
                    : Radio<int>(
                        value: row.optionId,
                        groupValue: isSelected ? row.optionId : null,
                        onChanged: (_) => onTap?.call(),
                      ),
              ),
            ),

            // название опции
            Expanded(
              child: Text(
                row.optionTitle,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // проценты
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // immediate result
                Text(
                  '${l10n.immediateLabel} ${(100 * row.immediate).round()} %',
                  style: theme.textTheme.bodySmall,
                ),
                // final result
                Text(
                  '${l10n.finalLabel} ${(100 * row.finalRes).round()} %',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),

            // голоса
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text('${row.votes}', style: theme.textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

class MockPollRow {
  const MockPollRow({
    required this.optionId,
    required this.optionTitle,
    required this.immediate,
    required this.finalRes,
    required this.votes,
  });

  final int optionId;
  final String optionTitle;
  final double immediate;
  final double finalRes;
  final int votes;

  static const List<MockPollRow> mockRows = [
    MockPollRow(
      optionId: 1,
      optionTitle: 'Красный',
      immediate: .40,
      finalRes: .45,
      votes: 11,
    ),
    MockPollRow(
      optionId: 2,
      optionTitle: 'Синий',
      immediate: .35,
      finalRes: .33,
      votes: 9,
    ),
    MockPollRow(
      optionId: 3,
      optionTitle: 'Зелёный',
      immediate: .25,
      finalRes: .22,
      votes: 7,
    ),
  ];
}
