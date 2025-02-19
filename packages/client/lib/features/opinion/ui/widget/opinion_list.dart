import 'package:flutter/material.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/opinion_cubit.dart';
import 'opinion_tile.dart';

class OpinionList extends StatelessWidget {
  const OpinionList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<OpinionCubit, OpinionState>(
      buildWhen: (_, c) => c.isSuccess,
      builder: (_, state) {
        return state.opinions.isEmpty
            ? SliverToBoxAdapter(
              child: Padding(
                padding: kPaddingAll,
                child: Text(
                  'There are no opinions yet',
                  style: textTheme.bodyMedium,
                ),
              ),
            )
            : SliverList.separated(
              key: ValueKey(state.opinions),
              itemCount: state.opinions.length,
              itemBuilder: (_, i) {
                final opinion = state.opinions[i];
                return Padding(
                  padding: kPaddingAll,
                  child: OpinionTile(
                    key: ValueKey(opinion),
                    isMine: state.checkIfIsMine(opinion),
                    opinion: opinion,
                  ),
                );
              },
              separatorBuilder:
                  (_, _) => const Divider(endIndent: 20, indent: 20),
            );
      },
    );
  }
}
