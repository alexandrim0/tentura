import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_image.dart';

import 'package:tentura/features/chat/ui/bloc/chat_news_cubit.dart';

class FriendListTile extends StatelessWidget {
  const FriendListTile({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      // Avatar
      leading: GestureDetector(
        onTap: () => context.pushRoute(
          ProfileViewRoute(id: profile.id),
        ),
        child: AvatarImage.small(userId: profile.id),
      ),

      title: Row(
        children: [
          // An Eye
          Padding(
            padding: kPaddingH,
            child: Icon(
              profile.isSeeingMe
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined,
            ),
          ),

          // Title
          Text(profile.title),
        ],
      ),

      // New messages indicator
      trailing: BlocSelector<ChatNewsCubit, ChatNewsState, int>(
        bloc: GetIt.I<ChatNewsCubit>(),
        selector: (state) => state.messages[profile.id]?.length ?? 0,
        builder: (context, newMessagesCount) => Badge.count(
          count: newMessagesCount,
          isLabelVisible: newMessagesCount > 0,
          backgroundColor: colorScheme.primaryContainer,
          textColor: colorScheme.onPrimaryContainer,
        ),
      ),

      onTap: () => context.pushRoute(
        ChatRoute(id: profile.id),
      ),
    );
  }
}
