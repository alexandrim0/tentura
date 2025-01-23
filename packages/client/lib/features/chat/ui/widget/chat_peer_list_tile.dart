import 'package:flutter/material.dart';

import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';

import '../bloc/chat_news_cubit.dart';

class ChatPeerListTile extends StatelessWidget {
  const ChatPeerListTile({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatNewsCubit = GetIt.I<ChatNewsCubit>();
    return ListTile(
      // Avatar
      leading: GestureDetector(
        onTap: () => chatNewsCubit.showProfile(profile.id),
        child: AvatarRated(profile: profile),
      ),

      title: Row(
        children: [
          // Title
          Text(profile.title),

          // An Eye
          Padding(
            padding: kPaddingH,
            child: Icon(
              profile.isSeeingMe
                  ? TenturaIcons.eyeOpen
                  : TenturaIcons.eyeClosed,
            ),
          ),
        ],
      ),

      // New messages indicator
      trailing: BlocSelector<ChatNewsCubit, ChatNewsState, int>(
        bloc: chatNewsCubit,
        selector: (state) => state.messages[profile.id]?.length ?? 0,
        builder: (context, newMessagesCount) => Badge.count(
          count: newMessagesCount,
          isLabelVisible: newMessagesCount > 0,
          backgroundColor: colorScheme.primaryContainer,
          textColor: colorScheme.onPrimaryContainer,
        ),
      ),

      onTap: () => chatNewsCubit.showChatWith(profile.id),
    );
  }
}
