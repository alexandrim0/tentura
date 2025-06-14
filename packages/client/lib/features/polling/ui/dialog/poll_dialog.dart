import 'dart:math';
import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/polling.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';

import '../bloc/polling_cubit.dart';

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

  late final _l10n = L10n.of(context)!;

  late final _theme = Theme.of(context);

  late final _pollingCubit = PollingCubit(polling: widget.polling);

  @override
  void initState() {
    super.initState();
    _pollingCubit.fetch();
  }

  @override
  void dispose() {
    _pollingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    key: ObjectKey(_pollingCubit),
    value: _pollingCubit,
    child: AlertDialog.adaptive(
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
      content: BlocConsumer<PollingCubit, PollingState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: commonScreenBlocListener,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Loader
                LinearPiActive.builder(context, state.isLoading),

                // Polling Question
                Text(
                  state.polling.question,
                  style: _theme.textTheme.bodySmall,
                ),

                // Total votes
                // TBD:
                // Padding(
                //   padding: kPaddingT,
                //   child: Text(
                //     _l10n.votedCountText(
                //       _rng.nextInt(100),
                //       state.polling.variants.length,
                //     ),
                //     style: _theme.textTheme.bodySmall!.copyWith(
                //       color: _theme.colorScheme.outline,
                //     ),
                //   ),
                // ),
                const Divider(),

                // Variants
                ...state.polling.variants.entries.map(
                  (variant) {
                    final isSelected = variant.key == state.chosenVariant;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      selected: isSelected,

                      // Radion Icon
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_on
                            : Icons.radio_button_off,
                      ),

                      // Question
                      title: Text(
                        variant.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _theme.textTheme.bodyMedium,
                      ),

                      // Results
                      subtitle: state.hasResults
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
                      trailing: state.hasResults
                          ? Text(
                              _rng.nextInt(10).toString(),
                              style: _theme.textTheme.bodyMedium,
                            )
                          : null,
                      onTap: state.hasResults
                          ? null
                          : () => _pollingCubit.chooseVariant(variant.key),
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),

      // Buttons
      actions: [
        // Send choice
        BlocSelector<PollingCubit, PollingState, bool>(
          bloc: _pollingCubit,
          selector: (state) => state.canVote,
          builder: (_, canVote) => FilledButton(
            onPressed: canVote ? _pollingCubit.vote : null,
            child: Text(_l10n.voteButton),
          ),
        ),

        // Close
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(_l10n.closeButton),
        ),
      ],
    ),
  );
}
