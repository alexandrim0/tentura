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
      builder: (context, state) {
        return state.opinions.isEmpty
            ? SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
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
                return OpinionTile(
                  key: ValueKey(opinion),
                  isMine: state.checkIfIsMine(opinion),
                  opinion: opinion,
                );
              },
              separatorBuilder: separatorBuilder,
            );
      },
    );
  }
}
