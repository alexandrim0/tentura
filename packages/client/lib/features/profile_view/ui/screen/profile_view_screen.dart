import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tentura/consts.dart';
import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/l10n/l10n.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/bottom_text_input.dart';

import 'package:tentura/features/opinion/ui/bloc/opinion_cubit.dart';
import 'package:tentura/features/opinion/ui/widget/opinion_list.dart';
import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';

import '../bloc/profile_view_cubit.dart';
import '../dialog/opinion_publish_dialog.dart';
import '../widget/profile_view_app_bar.dart';
import '../widget/profile_view_body.dart';

// TBD: refactor, remove FutureBuilder<Ids>, move all state to Cubit
@RoutePage()
class ProfileViewScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileViewScreen({
    @PathParam('id') this.id = '',
    @QueryParam(kQueryIsDeepLink) this.isDeepLink,
    super.key,
  });

  final String id;

  final String? isDeepLink;

  @override
  Widget wrappedRoute(BuildContext context) => FutureBuilder<Ids>(
    future: ProfileViewCubit.checkIfIdIsOpinion(id),
    builder: (_, state) {
      if (!state.hasData) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else if (state.hasError) {
        return Center(
          child: Text(state.error.toString()),
        );
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
    final l10n = L10n.of(context)!;
    final opinionCubit = context.read<OpinionCubit>();
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () async => Future.wait([
          context.read<ProfileViewCubit>().fetch(),
          opinionCubit.fetch(preserve: false),
        ]),
        child: CustomScrollView(
          slivers: [
            // Header
            ProfileViewAppBar(
              isFromDeepLink: isDeepLink == 'true',
            ),

            // Body
            const SliverPadding(
              padding: kPaddingAll,
              sliver: ProfileViewBody(),
            ),

            // Opinions
            SliverPadding(
              padding: kPaddingBottomTextInput,
              sliver: OpinionList(key: ValueKey(id)),
            ),
          ],
        ),
      ),

      // Text Input
      bottomSheet: BlocSelector<OpinionCubit, OpinionState, bool>(
        selector: (state) => state.hasMyOpinion,
        bloc: opinionCubit,
        builder: (_, hasMyOpinion) {
          final keyBottomTextInput = Key(
            'ProfileViewScreen:BottomTextInput:$hasMyOpinion',
          );
          return hasMyOpinion
              ? BottomTextInput(
                  hintText: l10n.onlyOneOpinion,
                )
              : BottomTextInput(
                  key: keyBottomTextInput,
                  hintText: l10n.writeOpinion,
                  onSend: (text) async => opinionCubit.addOpinion(
                    amount: await OpinionPublishDialog.show(context),
                    text: text,
                  ),
                );
        },
      ),
    );
  }
}
