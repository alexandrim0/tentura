import 'package:flutter/material.dart';

import 'package:tentura/app/router/root_router.dart';

import 'package:tentura/features/opinion/ui/bloc/opinion_cubit.dart';
import 'package:tentura/features/opinion/ui/widget/opinion_list.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import '../bloc/profile_cubit.dart';
import '../widget/profile_app_bar.dart';
import '../widget/profile_body.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) {
      final profile = GetIt.I<ProfileCubit>().state.profile;
      return OpinionCubit(myProfile: profile, userId: profile.id);
    },
    child: BlocListener<OpinionCubit, OpinionState>(
      listener: commonScreenBlocListener,
      child: this,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final opinionCubit = context.read<OpinionCubit>();
    final profileCubit = GetIt.I<ProfileCubit>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await Future.wait([profileCubit.fetch(), opinionCubit.fetch()]);
      },
      child: const CustomScrollView(
        slivers: [
          // Header
          ProfileAppBar(),

          // Profile
          SliverPadding(padding: kPaddingAll, sliver: ProfileBody()),

          // Opinions List
          SliverPadding(padding: kPaddingH, sliver: OpinionList()),
        ],
      ),
    );
  }
}
