import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura/ui/widget/tentura_icons.dart';

import '../../domain/entity/likable_entity.dart';
import '../../domain/typedef.dart';
import '../bloc/like_cubit.dart';

class LikeControl extends StatelessWidget {
  const LikeControl({
    required this.entity,
    super.key,
  });

  final LikableEntity entity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final likeCubit = GetIt.I<LikeCubit>();
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: theme.colorScheme.secondaryContainer,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(TenturaIcons.arrowUp),
            onPressed: () async =>
                likeCubit.addLikeAmount(entity: entity, amount: 1),
          ),
          StreamBuilder<LikeAmount>(
            key: ValueKey(entity),
            initialData: likeCubit.state.getLikeAmount(entity),
            stream: likeCubit.likeChanges.where((e) => e.id == entity.id),
            builder: (context, snapshot) => Text(
              (snapshot.data?.amount ?? 0).toString(),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: const Icon(TenturaIcons.arrowDown),
            onPressed: () async =>
                likeCubit.addLikeAmount(entity: entity, amount: -1),
          ),
        ],
      ),
    );
  }
}
