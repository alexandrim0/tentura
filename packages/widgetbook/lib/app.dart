import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/theme.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';

import 'package:tentura/features/chat/ui/bloc/chat_news_cubit.dart';
import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura/features/favorites/ui/bloc/favorites_cubit.dart';
import 'package:tentura/features/friends/ui/bloc/friends_cubit.dart';
import 'package:tentura/features/like/ui/bloc/like_cubit.dart';
import 'package:tentura/features/my_field/ui/bloc/my_field_cubit.dart';

import 'app.directories.g.dart';

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) => Widgetbook(
    darkTheme: themeDark,
    lightTheme: themeLight,
    directories: directories,
    addons: [
      // Have to be first
      ViewportAddon(IosViewports.all),
      MaterialThemeAddon(
        themes: [
          WidgetbookTheme(name: 'Dark', data: themeDark),
          WidgetbookTheme(name: 'Light', data: themeLight),
        ],
      ),
    ],
    appBuilder: (_, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: L10n.localizationsDelegates,
      onGenerateTitle: (context) => L10n.of(context)?.appTitle ?? kAppTitle,
      builder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ScreenCubit()),
          BlocProvider.value(value: GetIt.I<ChatNewsCubit>()),
          BlocProvider.value(value: GetIt.I<ContextCubit>()),
          BlocProvider.value(value: GetIt.I<FriendsCubit>()),
          BlocProvider.value(value: GetIt.I<LikeCubit>()),
          BlocProvider.value(value: GetIt.I<MyFieldCubit>()),
          BlocProvider.value(value: GetIt.I<FavoritesCubit>()),
        ],
        child: BlocListener<ScreenCubit, ScreenState>(
          listenWhen: (_, c) => c.isNavigating || c.hasError,
          // TBD: Navigation
          listener: (context, state) {},
          child: child,
        ),
      ),
    ),
  );
}
