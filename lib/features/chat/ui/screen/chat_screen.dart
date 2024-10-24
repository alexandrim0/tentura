import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat;

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';
import 'package:tentura/ui/bloc/state_base.dart';
import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';
import 'package:tentura/features/settings/ui/bloc/settings_cubit.dart';

import '../bloc/chat_cubit.dart';

@RoutePage()
class ChatScreen extends StatelessWidget implements AutoRouteWrapper {
  const ChatScreen({
    @queryParam this.id = '',
    super.key,
  });

  final String id;

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) {
          return ChatCubit(
            me: GetIt.I<ProfileCubit>().state.profile,
            friendId: id,
          );
        },
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();
    final chatTheme = switch (GetIt.I<SettingsCubit>().state.themeMode) {
      ThemeMode.dark => const chat.DarkChatTheme(),
      ThemeMode.light => const chat.DefaultChatTheme(),
      ThemeMode.system =>
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? const chat.DefaultChatTheme()
            : const chat.DarkChatTheme(),
    };
    return Scaffold(
      // Header
      appBar: AppBar(
        title: BlocSelector<ChatCubit, ChatState, String>(
          selector: (state) => state.friend.firstName ?? '...',
          builder: (context, state) => Text(state),
        ),
        leading: const DeepBackButton(),
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

      // Chat
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: showSnackBarError,
        listenWhen: (p, c) => c.hasError,
        buildWhen: (p, c) => c.status.isSuccess,
        builder: (context, state) => chat.Chat(
          dateIsUtc: true,
          theme: chatTheme,
          onMessageVisibilityChanged: chatCubit.onMessageVisibilityChanged,
          onSendPressed: chatCubit.onSendPressed,
          onEndReached: chatCubit.onEndReached,
          messages: state.messages,
          user: state.me,
        ),
      ),
    );
  }
}
