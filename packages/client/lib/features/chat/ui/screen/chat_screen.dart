import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/domain/entity/profile.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:tentura/ui/bloc/state_base.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/friends/ui/bloc/friends_cubit.dart';

import '../bloc/chat_cubit.dart';
import '../bloc/chat_news_cubit.dart';
import '../dialog/on_chat_clear_dialog.dart';
import '../widget/chat_list.dart';

@RoutePage()
class ChatScreen extends StatelessWidget implements AutoRouteWrapper {
  const ChatScreen({
    @queryParam this.id = '',
    super.key,
  });

  final String id;

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => ChatCubit(
          me: GetIt.I<AuthCubit>().state.currentAccount,
          friend: GetIt.I<FriendsCubit>().state.friends[id]!,
          updatesStream: GetIt.I<ChatNewsCubit>().updates,
        ),
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const DeepBackButton(),
          title: BlocSelector<ChatCubit, ChatState, Profile>(
            selector: (state) => state.friend,
            builder: (context, profile) => Row(
              children: [
                AvatarRated(
                  profile: profile,
                  size: 32,
                ),
                Padding(
                  padding: kPaddingH,
                  child: Text(
                    profile.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            PopupMenuButton<void>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    if (await OnChatClearDialog.show(context) ?? false) {
                      if (context.mounted) {
                        // TBD: remove when implemented
                        showSnackBar(
                          context,
                          text: 'Not implemented yet...',
                        );
                        await context.read<ChatCubit>().onChatClear();
                      }
                    }
                  },
                  child: const Text('Clear chat'),
                ),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: BlocSelector<ChatCubit, ChatState, FetchStatus>(
              selector: (state) => state.status,
              builder: (context, status) => status.isLoading
                  ? const LinearPiActive()
                  : const SizedBox(height: 4),
            ),
          ),
        ),
        body: BlocListener<ChatCubit, ChatState>(
          listener: showSnackBarError,
          listenWhen: (p, c) => c.hasError,
          child: const ChatList(),
        ),
      );
}
