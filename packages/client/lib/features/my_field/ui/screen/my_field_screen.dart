import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/auth/ui/bloc/auth_cubit.dart';
import 'package:tentura/features/beacon/ui/widget/beacon_tile.dart';
import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import '../bloc/my_field_cubit.dart';

@RoutePage()
class MyFieldScreen extends StatelessWidget implements AutoRouteWrapper {
  const MyFieldScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocSelector<AuthCubit, AuthState, String>(
        bloc: GetIt.I<AuthCubit>(),
        selector: (state) => state.currentAccountId,
        builder: (context, accountId) => MultiBlocProvider(
          key: ValueKey(accountId),
          providers: [
            BlocProvider.value(
              value: GetIt.I<ContextCubit>(),
            ),
            BlocProvider(
              create: (context) => MyFieldCubit(
                initialContext: GetIt.I<ContextCubit>().state.selected,
              ),
            ),
          ],
          child: BlocListener<ContextCubit, ContextState>(
            listenWhen: (p, c) => p.selected != c.selected,
            listener: (context, state) =>
                context.read<MyFieldCubit>().fetch(state.selected),
            child: this,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        minimum: kPaddingAll,
        child: Column(
          children: [
            // Context selector
            const ContextDropDown(key: Key('MyFieldContextSelector')),

            // Beacons list
            Expanded(
              child: BlocConsumer<MyFieldCubit, MyFieldState>(
                listenWhen: (p, c) => c.hasError,
                listener: showSnackBarError,
                buildWhen: (p, c) => c.hasNoError,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return RefreshIndicator.adaptive(
                    onRefresh: context.read<MyFieldCubit>().fetch,
                    child: ListView.separated(
                      itemCount: state.beacons.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final beacon = state.beacons[i];
                        return Padding(
                          padding: kPaddingV,
                          child: BeaconTile(
                            beacon: beacon,
                            key: ValueKey(beacon),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
