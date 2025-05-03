import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:tentura_root/l10n/l10n.dart';

import 'package:tentura/ui/bloc/screen_cubit.dart';
import 'package:tentura/ui/utils/ui_utils.dart';
import 'package:tentura/ui/widget/linear_pi_active.dart';

import '../bloc/invitation_cubit.dart';

@RoutePage()
class InvitationScreen extends StatelessWidget implements AutoRouteWrapper {
  const InvitationScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: GetIt.I<ScreenCubit>()),
      BlocProvider(create: (_) => InvitationCubit()..fetch()),
    ],
    child: MultiBlocListener(
      listeners: const [
        BlocListener<ScreenCubit, ScreenState>(
          listener: commonScreenBlocListener,
        ),
        BlocListener<InvitationCubit, InvitationState>(
          listener: commonScreenBlocListener,
        ),
      ],
      child: this,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final invitationCubit = context.read<InvitationCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.invitationScreenTitle),
        actions: [
          IconButton(
            onPressed: () async {
              final invitation = await invitationCubit.createInvitation();
              if (invitation != null) {
                // TBD: show dialog
              }
            },
            icon: const Icon(Icons.person_add_alt_1),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: BlocSelector<InvitationCubit, InvitationState, bool>(
            selector: (state) => state.isLoading,
            builder: LinearPiActive.builder,
            bloc: invitationCubit,
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async => invitationCubit.fetch(clear: true),
        child: BlocBuilder<InvitationCubit, InvitationState>(
          bloc: invitationCubit,
          buildWhen: (_, c) => c.isSuccess,
          builder: (_, state) {
            return ListView.separated(
              itemCount: state.invitations.length,
              itemBuilder: (_, i) {
                final invitation = state.invitations[i];
                if (state.invitations.length == i + 1) {
                  invitationCubit.fetch();
                }
                return ListTile(
                  title: Text(invitation.id),
                  subtitle: Text(invitation.createdAt.toString()),
                );
              },
              padding: kPaddingH + kPaddingT,
              separatorBuilder: separatorBuilder,
            );
          },
        ),
      ),
    );
  }
}
