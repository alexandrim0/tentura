import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:tentura/ui/l10n/l10n.dart';

class PollButton extends StatelessWidget {
  const PollButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return FilledButton.tonalIcon(
      icon: const Icon(Icons.poll),
      label: Text(l10n.showPollButton),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (ctx) => const _PollDialog(),
      ),
    );
  }
}

/// mock-данные
class _MockPollRow {
  const _MockPollRow({
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
}

const double _percentageVoted = .72;
const List<_MockPollRow> _mockRows = [
  _MockPollRow(
    optionId: 1,
    optionTitle: 'Красный',
    immediate: .40,
    finalRes: .45,
    votes: 11,
  ),
  _MockPollRow(
    optionId: 2,
    optionTitle: 'Синий',
    immediate: .35,
    finalRes: .33,
    votes: 9,
  ),
  _MockPollRow(
    optionId: 3,
    optionTitle: 'Зелёный',
    immediate: .25,
    finalRes: .22,
    votes: 7,
  ),
];

//  Dialog
class _PollDialog extends StatefulWidget {
  const _PollDialog();
  @override
  State<_PollDialog> createState() => _PollDialogState();
}

class _PollDialogState extends State<_PollDialog> {
  // mock-статус юзера
  bool _hasVoted = false;
  int? _selectedOptionId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalVotes = _mockRows.map((e) => e.votes).sum;
    final l10n = L10n.of(context)!;

    return AlertDialog(
      title: Text(l10n.pollDialogTitle, style: theme.textTheme.bodyMedium),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // описание опроса
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Назовите ваш любимый цвет? А тут я ещё допишу текста,'
                ' чтобы он был подлиннее. И ещё подлиннее. И ещё немного'
                ' ещё чуть-чуть. Вот так в целом нормально, я думаю.',
                style: theme.textTheme.bodySmall,
              ),
            ),
            // блок «сколько проголосовало»
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.votedCountText(
                  (100 * _percentageVoted).round(),
                  totalVotes,
                ),
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            const Divider(height: 0),
            // список опций
            ..._mockRows.map(
              (row) => _OptionTile(
                row: row,
                hasVoted: _hasVoted,
                isSelected: _selectedOptionId == row.optionId,
                onTap: _hasVoted
                    ? null // уже проголосовал — нельзя менять напрямую
                    : () => setState(() => _selectedOptionId = row.optionId),
              ),
            ),
            const Divider(height: 16),
          ],
        ),
      ),

      // кнопки
      actions: [
        if (_hasVoted)
          TextButton(
            onPressed: () => setState(() {
              _hasVoted = false;
              _selectedOptionId = null;
            }),
            child: Text(l10n.changeVoteButton),
          ),

        // «Проголосовать» видно только до первого голоса
        if (!_hasVoted)
          FilledButton(
            onPressed: _selectedOptionId == null
                ? null
                : () => setState(() => _hasVoted = true),
            child: Text(l10n.voteButton),
          ),

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.closeButton),
        ),
      ],
    );
  }
}

/// Option tile
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.row,
    required this.hasVoted,
    required this.isSelected,
    this.onTap,
  });

  final _MockPollRow row;
  final bool hasVoted;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // «до» и «после»
    Widget stat(String label, double value) => Text(
      '$label ${(100 * value).round()} %',
      style: theme.textTheme.bodySmall,
    );
    final l10n = L10n.of(context)!;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // визуальный индикатор выбора
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: hasVoted
                  ? Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
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
                stat(l10n.immediateLabel, row.immediate), // immediate result
                stat(l10n.finalLabel, row.finalRes), // final result
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
