import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura_root/i10n/I10n.dart';
import 'package:tentura/domain/entity/opinion.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/bottom_text_input.dart';

import 'package:tentura/features/opinion/ui/bloc/opinion_cubit.dart';
import 'package:tentura/features/opinion/ui/widget/opinion_list.dart';
import 'package:tentura/features/opinion/data/repository/opinion_repository.dart';
import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';

import '../bloc/profile_view_cubit.dart';
import '../dialog/opinion_publish_dialog.dart';
import '../widget/profile_view_app_bar.dart';
import '../widget/profile_view_body.dart';

typedef Ids = ({String profileId, Opinion? opinion});

@RoutePage()
class ProfileViewScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileViewScreen({@queryParam this.id = '', super.key});

  final String id;

  @override
  Widget wrappedRoute(BuildContext context) => FutureBuilder<Ids>(
    future: () async {
      if (id.startsWith('U')) {
        return (profileId: id, opinion: null);
      } else if (id.startsWith('O')) {
        final result = await GetIt.I<OpinionRepository>().fetchById(id);
        return (profileId: result.objectId, opinion: result);
      } else {
        throw Exception('Wrong id prefix [$id]');
      }
    }(),
    builder: (context, state) {
      if (!state.hasData) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else if (state.hasError) {
        Center(child: Text(state.error.toString()));
      }
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: GetIt.I<ScreenCubit>()),
          BlocProvider(
            create: (_) => ProfileViewCubit(id: state.data!.profileId),
          ),
          BlocProvider(
            create: (_) {
              final opinion = state.data?.opinion;
              return OpinionCubit(
                userId: state.data!.profileId,
                opinions: opinion == null ? null : [opinion],
                myProfile: GetIt.I<ProfileCubit>().state.profile,
              );
            },
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
            BlocListener<ScreenCubit, ScreenState>(
              listener: commonScreenBlocListener,
            ),
          ],
          child: this,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final i10n = I10n.of(context)!;
    final opinionCubit = context.read<OpinionCubit>();
    final profileViewCubit = context.read<ProfileViewCubit>();
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh:
            () async =>
                Future.wait([profileViewCubit.fetch(), opinionCubit.fetch()]),
        child: CustomScrollView(
          slivers: [
            // Header
            const ProfileViewAppBar(),

            // Body
            const SliverPadding(
              padding: kPaddingAll,
              sliver: ProfileViewBody(),
            ),

            // Opinions
            SliverPadding(
              padding: kPaddingH,
              sliver: OpinionList(key: ValueKey(id)),
            ),
          ],
        ),
      ),

      // Text Input
      bottomSheet: BlocSelector<OpinionCubit, OpinionState, bool>(
        selector: (state) => state.hasMyOpinion,
        bloc: opinionCubit,
        builder:
            (_, hasMyOpinion) =>
                hasMyOpinion
                    ? BottomTextInput(hintText: i10n.onlyOneOpinion)
                    : BottomTextInput(
                      hintText: i10n.writeOpinion,
                      onSend:
                          (text) async => opinionCubit.addOpinion(
                            amount: await OpinionPublishDialog.show(context),
                            text: text,
                          ),
                    ),
      ),
    );
  }
}
