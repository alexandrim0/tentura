import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/bloc/state_base.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_image.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';
import 'package:tentura/ui/widget/show_more_text.dart';
import 'package:tentura/ui/widget/gradient_stack.dart';
import 'package:tentura/ui/widget/deep_back_button.dart';
import 'package:tentura/ui/widget/avatar_positioned.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';

import '../bloc/profile_view_cubit.dart';

@RoutePage()
class ProfileViewScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileViewScreen({
    @queryParam this.id = '',
    super.key,
  });

  final String id;

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => ProfileViewCubit(id: id),
        child: BlocListener<ProfileViewCubit, ProfileViewState>(
          listener: commonScreenBlocListener,
          child: this,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewCubit, ProfileViewState>(
      buildWhen: (p, c) => c.isSuccess || c.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        final profile = state.profile;
        final beacons = state.beacons;
        final textTheme = Theme.of(context).textTheme;
        final profileViewCubit = context.read<ProfileViewCubit>();
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
                    itemBuilder: (context) => <PopupMenuEntry<void>>[
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
                actionsIconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                floating: true,
                leading: const DeepBackButton(
                  color: Colors.black,
                ),
                expandedHeight: GradientStack.defaultHeight,

                // Avatar
                flexibleSpace: FlexibleSpaceBar(
                  background: GradientStack(
                    children: [
                      AvatarPositioned(
                        child: AvatarImage(
                          userId: profile.imageId,
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
                      Text(
                        profile.title.isEmpty ? 'No name' : profile.title,
                        textAlign: TextAlign.left,
                        style: textTheme.headlineLarge,
                      ),
                      const Padding(padding: kPaddingSmallV),

                      // Description
                      ShowMoreText(
                        profile.description,
                        style: ShowMoreText.buildTextStyle(context),
                      ),
                      const Divider(),

                      const Padding(padding: kPaddingSmallT),

                      Text(
                        'Beacons',
                        textAlign: TextAlign.left,
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),

              // Beacons
              if (beacons.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: kPaddingAll,
                    child: Text(
                      'There are no beacons yet',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                SliverList.separated(
                  key: ValueKey(beacons),
                  itemCount: beacons.length,
                  itemBuilder: (context, i) {
                    final beacon = beacons[i];
                    return Padding(
                      padding: kPaddingAll,
                      child: BeaconTile(
                        beacon: beacon,
                        key: ValueKey(beacon),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      const Divider(endIndent: 20, indent: 20),
                ),

              // Show more
              if (beacons.isNotEmpty && state.hasNotReachedMax)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: kPaddingAll,
                    child: TextButton(
                      onPressed: profileViewCubit.fetchMore,
                      child: const Text('Show more'),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
