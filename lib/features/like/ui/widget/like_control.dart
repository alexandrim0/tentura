import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura/domain/entity/likable.dart';
import 'package:tentura/domain/entity/repository_event.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/like_cubit.dart';

class LikeControl extends StatelessWidget {
  const LikeControl({
    required this.entity,
    super.key,
  });

  final Likable entity;

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
          StreamBuilder<RepositoryEvent<Likable>>(
            key: ValueKey(entity),
            initialData: RepositoryEventCreate(entity),
            stream: likeCubit.likeChanges.where((e) => e.id == entity.id),
            builder: (context, snapshot) => Text(
              (snapshot.data?.value.votes ?? 0).toString(),
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
