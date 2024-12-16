import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_image.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';
import 'package:tentura/ui/widget/gradient_stack.dart';
import 'package:tentura/ui/widget/avatar_positioned.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_mine_list.dart';

import '../bloc/profile_cubit.dart';
import '../widget/profile_mine_menu_button.dart';

@RoutePage()
class ProfileMineScreen extends StatelessWidget {
  const ProfileMineScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<ProfileCubit, ProfileState>(
        bloc: GetIt.I<ProfileCubit>(),
        listenWhen: (p, c) => c.hasError,
        listener: showSnackBarError,
        buildWhen: (p, c) => c.hasNoError,
        builder: (context, state) {
          final profile = state.profile;
          final textTheme = Theme.of(context).textTheme;
          return RefreshIndicator.adaptive(
            onRefresh: () async => Future.wait([
              GetIt.I<BeaconCubit>().fetch(),
              GetIt.I<ProfileCubit>().fetch(),
            ]),
            child: CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  key: Key('ProfileMineScreen:${profile.imageId}'),
                  actions: [
                    // Graph View
                    IconButton(
                      icon: const Icon(TenturaIcons.graph),
                      onPressed: () async =>
                          context.pushRoute(GraphRoute(focus: profile.id)),
                    ),

                    // Share
                    ShareCodeIconButton.id(profile.id),

                    // More
                    const ProfileMineMenuButton(),
                  ],
                  actionsIconTheme: const IconThemeData(
                    color: Colors.black,
                  ),
                  floating: true,
                  expandedHeight: GradientStack.defaultHeight,
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

                // Profile
                SliverToBoxAdapter(
                  key: ValueKey(profile),
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
                            style: textTheme.headlineLarge,
                            textAlign: TextAlign.left,
                          ),
                        ),

                        // Description
                        Padding(
                          padding: kPaddingSmallV,
                          child: Text(
                            profile.description,
                            style: textTheme.bodyMedium,
                          ),
                        ),

                        // Divider
                        const Divider(),

                        // Create
                        Padding(
                          padding: kPaddingSmallT,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Beacons',
                                style: textTheme.titleLarge,
                              ),
                              FilledButton(
                                onPressed: () async => context
                                    .pushRoute(const BeaconCreateRoute()),
                                child: const Text('Create'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Beacons List
                const BeaconMineList(),
              ],
            ),
          );
        },
      );
}
