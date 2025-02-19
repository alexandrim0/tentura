import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/features/opinion/ui/bloc/opinion_cubit.dart';
import 'package:tentura/features/opinion/ui/widget/opinion_list.dart';
import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';

import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_rated.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/gradient_stack.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/avatar_positioned.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import '../bloc/profile_view_cubit.dart';

@RoutePage()
class ProfileViewScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileViewScreen({@queryParam this.id = '', super.key});

  final String id;

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ProfileViewCubit(id: id)),
      BlocProvider(
        create:
            (_) => OpinionCubit(
              objectId: id,
              myProfile: GetIt.I<ProfileCubit>().state.profile,
            ),
      ),
    ],
    child: MultiBlocListener(
      listeners: const [
        BlocListener<ProfileViewCubit, ProfileViewState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<OpinionCubit, OpinionState>(
          listener: commonScreenBlocListener,
        ),
      ],
      child: this,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final profileViewCubit = context.read<ProfileViewCubit>();
    return BlocBuilder<ProfileViewCubit, ProfileViewState>(
      buildWhen: (_, c) => c.isSuccess || c.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final profile = state.profile;
        final textTheme = Theme.of(context).textTheme;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                actions: [
                  // Graph View
                  IconButton(
                    icon: const Icon(TenturaIcons.graph),
                    onPressed: () => profileViewCubit.showGraph(profile.id),
                  ),

                  // Share
                  ShareCodeIconButton.id(profile.id),

                  // More
                  PopupMenuButton(
                    itemBuilder:
                        (_) => <PopupMenuEntry<void>>[
                          if (profile.isFriend)
                            PopupMenuItem(
                              onTap: profileViewCubit.removeFriend,
                              child: const Text('Remove from my field'),
                            )
                          else
                            PopupMenuItem(
                              onTap: profileViewCubit.addFriend,
                              child: const Text('Add to my field'),
                            ),
                        ],
                  ),
                ],
                actionsIconTheme: const IconThemeData(color: Colors.black),
                leading: const DeepBackButton(color: Colors.black),
                expandedHeight: GradientStack.defaultHeight,
                floating: true,

                // Avatar
                flexibleSpace: FlexibleSpaceBar(
                  background: GradientStack(
                    children: [
                      AvatarPositioned(
                        child: AvatarRated(
                          profile: profile,
                          withRating: false,
                          size: AvatarPositioned.childSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: kPaddingH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: kPaddingSmallV,
                        child: Text(
                          profile.title.isEmpty ? 'No name' : profile.title,
                          textAlign: TextAlign.left,
                          style: textTheme.headlineLarge,
                        ),
                      ),

                      // Description
                      ShowMoreText(
                        profile.description,
                        style: ShowMoreText.buildTextStyle(context),
                      ),

                      Padding(
                        padding: kPaddingSmallV,
                        child: Text(
                          'Community Feedback',
                          textAlign: TextAlign.left,
                          style: textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Opinions
              OpinionList(key: ValueKey(id)),
            ],
          ),
        );
      },
    );
  }
}
