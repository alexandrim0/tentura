import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/l10n/l10n.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/chat/ui/widget/chat_peer_list_tile.dart';

import '../bloc/friends_cubit.dart';

@RoutePage()
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsCubit = GetIt.I<FriendsCubit>();
    final l10n = L10n.of(context)!;
    return SafeArea(
      child: BlocBuilder<FriendsCubit, FriendsState>(
        bloc: friendsCubit,
        buildWhen: (p, c) => c.isSuccess,
        builder: (context, state) {
          late final friends = state.friends.values.toList();
          return RefreshIndicator.adaptive(
            onRefresh: friendsCubit.fetch,
            child:
                state.friends.isEmpty
                    // Empty state
                    ? Center(
                      child: Text(
                        l10n.labelNothingHere,
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    )
                    // Friends List
                    : ListView.separated(
                      padding: kPaddingAll,
                      itemCount: friends.length,
                      itemBuilder: (context, i) {
                        final profile = friends[i];
                        return ChatPeerListTile(
                          key: ValueKey(profile),
                          profile: profile,
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(),
                    ),
          );
        },
      ),
    );
  }
}
