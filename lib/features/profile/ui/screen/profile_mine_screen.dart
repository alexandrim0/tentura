import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/avatar_image.dart';
import 'package:tentura/ui/widget/tentura_icons.dart';
import 'package:tentura/ui/widget/gradient_stack.dart';
import 'package:tentura/ui/widget/avatar_positioned.dart';
import 'package:tentura/ui/widget/share_code_icon_button.dart';

import 'package:tentura/features/beacon/ui/bloc/beacon_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_mine_tile.dart';

import '../bloc/profile_cubit.dart';
import '../widget/profile_mine_menu_button.dart';

@RoutePage()
class ProfileMineScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileMineScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: GetIt.I<BeaconCubit>()),
          BlocProvider.value(value: GetIt.I<ProfileCubit>()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<BeaconCubit, BeaconState>(
              listenWhen: (p, c) => c.hasError,
              listener: showSnackBarError,
            ),
            BlocListener<ProfileCubit, ProfileState>(
              listenWhen: (p, c) => c.hasError,
              listener: showSnackBarError,
            ),
          ],
          child: this,
        ),
      );

  @override
  Widget build(BuildContext context) => RefreshIndicator.adaptive(
        onRefresh: () async => Future.wait([
          GetIt.I<BeaconCubit>().fetch(),
          GetIt.I<ProfileCubit>().fetch(),
        ]),
        child: Builder(
          builder: (context) {
            final textTheme = Theme.of(context).textTheme;
            final beaconsCubit = context.watch<BeaconCubit>();
            final profileCubit = context.watch<ProfileCubit>();
            final beacons = beaconsCubit.state.beacons;
            final profile = profileCubit.state.profile;
            return CustomScrollView(
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
                            textAlign: TextAlign.left,
                            style: textTheme.headlineLarge,
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
                if (beacons.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: kSpacingMedium,
                        bottom: kSpacingMedium,
                        left: kSpacingMedium,
                      ),
                      child: Text(
                        'There are no beacons yet',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  SliverList.separated(
                    key: const PageStorageKey('MyBeaconsListView'),
                    itemCount: beacons.length,
                    itemBuilder: (context, i) {
                      final beacon = beacons[i];
                      return Padding(
                        padding: kPaddingH,
                        child: BeaconMineTile(
                          beacon: beacon,
                          key: ValueKey(beacon),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(
                      endIndent: 20,
                      indent: 20,
                    ),
                  ),
              ],
            );
          },
        ),
      );
}
