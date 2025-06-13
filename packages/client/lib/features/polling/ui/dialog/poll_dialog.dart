import 'dart:math';
import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/polling.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';

class PollDialog extends StatefulWidget {
  static Future<void> show(
    BuildContext context, {
    required Polling polling,
  }) => showDialog<void>(
    context: context,
    builder: (_) => PollDialog(
      polling: polling,
    ),
  );

  const PollDialog({required this.polling, super.key});

  final Polling polling;

  @override
  State<PollDialog> createState() => PollDialogState();
}

class PollDialogState extends State<PollDialog> {
  final _rng = Random.secure();

  late final _theme = Theme.of(context);

  late final _l10n = L10n.of(context)!;

  late String? _chosenVariant = widget.polling.selection.firstOrNull;

  late bool _choiceSent = _chosenVariant != null;

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
    insetPadding: kPaddingAll,
    contentPadding: kPaddingV + kPaddingH,
    scrollable: true,

    // Title
    title: Text(
      _l10n.pollDialogTitle,
      style: _theme.textTheme.bodyMedium,
      textAlign: TextAlign.center,
    ),

    // Body
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Loader
          LinearPiActive.builder(context, false),

          // Polling Question
          Text(
            widget.polling.question,
            style: _theme.textTheme.bodySmall,
          ),

          // Total votes
          Padding(
            padding: kPaddingT,
            child: Text(
              _l10n.votedCountText(
                _rng.nextInt(100),
                widget.polling.variants.length,
              ),
              style: _theme.textTheme.bodySmall!.copyWith(
                color: _theme.colorScheme.outline,
              ),
            ),
          ),
          const Divider(),

          // Variants
          ...widget.polling.variants.entries.map(
            (variant) => ListTile(
              contentPadding: EdgeInsets.zero,
              selected: variant.key == _chosenVariant,
              leading: Icon(
                variant.key == _chosenVariant
                    ? Icons.radio_button_on
                    : Icons.radio_button_off,
              ),

              // Question
              title: Text(
                variant.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Results
              subtitle: _choiceSent
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // immediate result
                        Text(
                          '${_l10n.immediateLabel} '
                          '${(100 * _rng.nextDouble()).round()} %',
                          style: _theme.textTheme.bodySmall,
                        ),
                        // final result
                        Text(
                          '${_l10n.finalLabel} '
                          '${(100 * _rng.nextDouble()).round()} %',
                          style: _theme.textTheme.bodySmall,
                        ),
                      ],
                    )
                  : null,

              // Count
              trailing: _choiceSent
                  ? Text(
                      _rng.nextInt(10).toString(),
                      style: _theme.textTheme.bodyMedium,
                    )
                  : null,
              onTap: _choiceSent
                  ? null
                  : () => setState(() => _chosenVariant = variant.key),
            ),
          ),
          const Divider(),
        ],
      ),
    ),

    // Buttons
    actions: [
      // Send choice
      FilledButton(
        onPressed: _choiceSent
            ? null
            : () => setState(() => _choiceSent = true),
        child: Text(_l10n.voteButton),
      ),

      // Close
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(_l10n.closeButton),
      ),
    ],
  );
}
