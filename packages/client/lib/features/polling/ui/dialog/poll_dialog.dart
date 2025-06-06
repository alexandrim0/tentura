import 'package:flutter/material.dart';

import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import '../widget/poll_variant_tile.dart';

class PollDialog extends StatefulWidget {
  static Future<void> show(BuildContext context) =>
      showDialog<void>(context: context, builder: (_) => const PollDialog());

  const PollDialog({super.key});

  @override
  State<PollDialog> createState() => PollDialogState();
}

class PollDialogState extends State<PollDialog> {
  late final _theme = Theme.of(context);
  late final _l10n = L10n.of(context)!;

  // mock-статус юзера
  bool _hasVoted = false;

  int? _selectedOptionId;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(_l10n.pollDialogTitle, style: _theme.textTheme.bodyMedium),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Polling Question
          Text(
            'Назовите ваш любимый цвет? А тут я ещё допишу текста,'
            ' чтобы он был подлиннее. И ещё подлиннее. И ещё немного'
            ' ещё чуть-чуть. Вот так в целом нормально, я думаю.',
            style: _theme.textTheme.bodySmall,
          ),

          // блок «сколько проголосовало»
          Padding(
            padding: kPaddingT,
            child: Text(
              _l10n.votedCountText(72, MockPollRow.mockRows.length),
              style: _theme.textTheme.bodySmall!.copyWith(
                color: _theme.colorScheme.outline,
              ),
            ),
          ),
          const Divider(),

          // Variants
          ...MockPollRow.mockRows.map(
            (row) => PollVariantTile(
              row: row,
              hasVoted: _hasVoted,
              isSelected: _selectedOptionId == row.optionId,
              onTap: _hasVoted
                  ? null // уже проголосовал — нельзя менять напрямую
                  : () => setState(() => _selectedOptionId = row.optionId),
            ),
          ),
          const Divider(),
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
          child: Text(_l10n.changeVoteButton),
        )
      else
        // «Проголосовать» видно только до первого голоса
        FilledButton(
          onPressed: _selectedOptionId == null
              ? null
              : () => setState(() => _hasVoted = true),
          child: Text(_l10n.voteButton),
        ),

      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(_l10n.closeButton),
      ),
    ],
  );
}
